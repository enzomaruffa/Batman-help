//
//  MenuViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MenuViewController: UIViewController {
    
    //MARK: - Variable Outlets
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var wikiButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    //MARK: - Variables
    var locationManager: CLLocationManager?
    var currentLocation: MKUserLocation? {
        didSet {
            if currentLocation != nil {
                reportButton.isEnabled = true
            } else {
                reportButton.isEnabled = false
            }
        }
    }
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateStyle = DateFormatter.Style.short
        return formatter
    }()
    
    var characterDatabase: DatabaseAccess = Singleton.shared
    var sceneDatabase: DatabaseAccess = CloudKitManager.shared
    
    var scenes: [SceneLocation] = []
    
    var showingButtons = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapKit()

        menuContainer.layer.cornerRadius = menuContainer.frame.height/2
        
        wikiButton.alpha = 0
        reportButton.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Functions
    func setupMapKit() {
        
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {

            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest

            switch CLLocationManager.authorizationStatus() {

            case .authorizedAlways, .authorizedWhenInUse:
                // Location services authorised.
                // Start tracking the user.
                locationManager?.startUpdatingLocation()
                mapView.showsUserLocation = true

            default:
                // Request access for location services.
                // This will call didChangeAuthorizationStatus on completion.
                locationManager?.requestWhenInUseAuthorization()
            }
        }
        
        let location = CLLocationCoordinate2D(latitude: -25.452767,
            longitude: -49.249728)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
        sceneDatabase.getAllScenes { (scenes) in
            self.scenes = scenes
            for scene in scenes {
                let annotation = MKPointAnnotation()
                annotation.coordinate = scene.location
                annotation.title = scene.name
                annotation.subtitle = scene.type == .place ? "Place" : "Scene"
                self.mapView.addAnnotation(annotation)
            }
        }
            
    }
    
    //MARK: - Actions Outlets
    @IBAction func centralTapped(_ sender: Any) {
        print("central tapped")
        if !showingButtons {
            UIView.animate(withDuration: 0.6, animations: {
                self.self.wikiButton.alpha = 1
                self.reportButton.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.wikiButton.alpha = 0
                self.reportButton.alpha = 0
            })
        }
        showingButtons.toggle()
    }
    
    //MARK: - Functions
    @IBAction func reportPressed(_ sender: Any) {
        self.presentPhotoPicker(sourceType: .camera)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "report" {
            let vc = segue.destination as? ReportViewController
            
            let image = sender as? UIImage
            vc!.crimeImage = image

            vc!.currentLocation = self.currentLocation?.coordinate
        }
    }
    
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image = info[.originalImage] as! UIImage
        
        // Segue to view with this image
        performSegue(withIdentifier: "report", sender: image)
    }
}


// MARK: - CLLocationManagerDelegate
extension MenuViewController: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {

        case .authorizedAlways, .authorizedWhenInUse:
            // Location services are authorised, track the user.
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true

        case .denied, .restricted:
            // Location services not authorised, stop tracking the user.
            locationManager?.stopUpdatingLocation()
            mapView.showsUserLocation = false
            currentLocation = nil

        default:
            // Location services pending authorisation.
            // Alert requesting access is visible at this point.
            currentLocation = nil
        }
    }
}

// MARK: - MKMapViewDelegate
extension MenuViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentLocation = userLocation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        let annotationIdentifier = "AnnotationIdentifier"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        let sceneInfo = scenes.filter({ $0.location == annotation.coordinate }).first!
        
        var image: UIImage = UIImage()
        if sceneInfo.type == .place {
            image = UIImage(named: "batman-yellow")!
        } else if sceneInfo.type == .scene {
            if sceneInfo.sceneResolved {
                image = UIImage(named: "batman-blue")!
            } else {
                image = UIImage(named: "batman-red")!
            }
        }
        
        annotationView!.image = image
        
        let batmanImage = image.cgImage
        annotationView!.image = UIImage(cgImage: batmanImage!, scale: 4, orientation: .up)
            
        return annotationView

    }

}
