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
    @IBOutlet weak var placeButton: UIButton!
    
    //MARK: - Variables
    var locationManager: CLLocationManager?
    var currentLocation: MKUserLocation? {
        didSet {
            if currentLocation != nil {
                reportButton.isEnabled = true
                placeButton.isEnabled = true
            } else {
                reportButton.isEnabled = false
                placeButton.isEnabled = false
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
    
    var showingButtons = true
    
    //MARK: - Constraints Outlets
    @IBOutlet weak var reportTrailing: NSLayoutConstraint!
    @IBOutlet weak var wikiLeading: NSLayoutConstraint!
    
    @IBOutlet weak var reportBottom: NSLayoutConstraint!
    @IBOutlet weak var wikiBottom: NSLayoutConstraint!
    @IBOutlet weak var placeBottom: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapKit()
        
        menuContainer.layer.cornerRadius = menuContainer.frame.height/2
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .mapScenesUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateScenes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Functions
    @objc fileprivate func updateScenes() {
        self.sceneDatabase.getAllScenes { (scenes) in
            DispatchQueue.main.async {
                if self.scenes.count != scenes.count {
                    self.scenes = scenes
                    let originalAnnotations = self.mapView.annotations
                    self.generateMapAnnotations(scenes)
                    self.mapView.removeAnnotations(originalAnnotations)
                }
            }
        }
    }
    
    fileprivate func generateMapAnnotations(_ scenes: [SceneLocation]) {
        for scene in scenes {
            DispatchQueue.main.async {
                let annotation = MKPointAnnotation()
                annotation.coordinate = scene.location
                annotation.title = scene.name
                annotation.subtitle = scene.type == .place ? "Place" : "Scene"
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
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
            DispatchQueue.main.async {
                self.scenes = scenes
                self.generateMapAnnotations(scenes)
            }
        }
        
    }
    
    func toggleButtons(show: Bool) {
        let animationTime = 0.8
        if show {
            UIView.animate(withDuration: animationTime) {
                self.reportBottom.constant = 20
                self.reportTrailing.constant = 0
                
                self.wikiBottom.constant = 20
                self.wikiLeading.constant = 0
                
                self.placeBottom.constant = 70
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: animationTime) {
                let viewSize = self.menuContainer.frame.width
                self.reportBottom.constant = -viewSize
                self.reportTrailing.constant = viewSize * 0.9
                
                self.wikiBottom.constant = -viewSize
                self.wikiLeading.constant = -viewSize * 0.9
                
                self.placeBottom.constant = -viewSize
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Actions Outlets
    @IBAction func centralTapped(_ sender: Any) {
        print("central tapped")
        showingButtons.toggle()
        toggleButtons(show: showingButtons)
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
    
    fileprivate func createPlaceAnnotationView(_ annotationView: MKAnnotationView?) {
        annotationView?.image = UIImage(named: "signal-place")?.resized(withPercentage: 0.25)
    }
    
    fileprivate func createSceneResolvedAnnotationView(_ annotationView: MKAnnotationView?) {
        annotationView?.image = UIImage(named: "batman-blue")?.resized(withPercentage: 0.25)
    }
    
    fileprivate func createCircleView(withSize size: CGRect, andStroke strokeWidth: CGFloat, withColor color: UIColor) -> UIView {
        let view = UIView(frame: size)
        
        view.backgroundColor = .clear
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = strokeWidth
        
        view.layer.cornerRadius = size.width/2
        
        return view
    }
    
    fileprivate func createSceneThreatAnnotationView(_ sceneInfo: SceneLocation, _ annotationView: MKAnnotationView?) {
        if sceneInfo.threatLevel == 0 {
            annotationView?.image = UIImage(named: "signal-beta")?.resized(withPercentage: 0.05)
        } else if sceneInfo.threatLevel == 1 {
            annotationView?.image = UIImage(named: "signal-alpha")?.resized(withPercentage: 0.05)
        } else {
            let imageRect = CGRect(x: 0, y: 0, width: 45, height: 45)
            
            let imageView = UIImageView(frame: imageRect)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = false
            imageView.image = UIImage(named: "signal-omega")
            
            let circleView = createCircleView(withSize: imageRect, andStroke: 1, withColor: .neonRed)
            
            annotationView?.addSubview(circleView)
            annotationView?.addSubview(imageView)
        }
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
        
        if let sceneInfo = scenes.filter({ $0.location == annotation.coordinate }).first {
            
            if sceneInfo.type == .place {
                createPlaceAnnotationView(annotationView)
            } else if sceneInfo.type == .scene {
                if sceneInfo.sceneResolved! {
                    createSceneResolvedAnnotationView(annotationView)
                } else {
                    createSceneThreatAnnotationView(sceneInfo, annotationView)
                }
                
            }
        }
        
        return annotationView
    }
    
}

extension Notification.Name {
    static let mapScenesUpdate = Notification.Name("mapScenesUpdate")
}
