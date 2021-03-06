//
//  MenuViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import MapKit
import MapKitGoogleStyler
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
    
    var menuButtonWidth: CGFloat!
    
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
    
    let logger: ConsoleDebugLogger = ConsoleDebugLogger.shared
    
    let hapticMCustomanager: HapticManager = HapticManager.shared
    let hapticNotificationManager = UINotificationFeedbackGenerator()
    let hapticFeedbackManager = UIImpactFeedbackGenerator()
    
    private let resizeSize: CGFloat = 0.2
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapKit()
        
        menuContainer.layer.cornerRadius = menuContainer.frame.height/2
        menuButtonWidth = menuContainer.frame.width
        
        toggleButtons(show: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .mapScenesUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logger.log(message: "")
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateScenes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logger.log(message: "")
        super.viewDidDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Functions
    @objc fileprivate func updateScenes(_ notification: NSNotification? = nil) {
        
        let sceneDict = notification?.userInfo as? [String: SceneLocation]
        let scene = sceneDict?["scene"]
        
        self.logger.log(message: "Notification received on main with scene \(scene)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sceneDatabase.getAllScenes { (scenes) in
                DispatchQueue.main.async {
                    
                    // Check if scene exists and is on the list or the count is different
                    
                    var newScenes = scenes
                    
                    if let scene = scene {
                        self.logger.log(message: "Removing equal scenes. Current count \(newScenes.count)")
                        
                        newScenes.removeAll(where: { $0.location == scene.location })
                        
                        self.logger.log(message: "After removal now we have \(scenes.count)")
                            
                            self.logger.log(message: "Adding scene to scenes")
                        newScenes.append(scene)
                    }
                    
                    self.logger.log(message: "Updating annotations on main thread")
                    self.logger.log(message: "Curent scene count: \(newScenes.count)")
                    self.scenes = newScenes
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.generateMapAnnotations(newScenes)
                    
                }
            }
        }
    }
    
    fileprivate func generateMapAnnotations(_ scenes: [SceneLocation]) {
        logger.log(message: "Generating \(scenes.count) markers")
        for scene in scenes {
            DispatchQueue.main.async {
                self.logger.log(message: "Adding annotation on \(scene.location)")
                let annotation = SceneLocationAnnotation(sceneLocation: scene)
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
        
        configureTileOverlay()
        
    }
    
    func toggleButtons(show: Bool) {
        let animationTime = 0.25
        
        hapticMCustomanager.playMenuToggle(withDuration: animationTime, opening: show)
        
        if show {
            UIView.animate(withDuration: animationTime) {
                
                let xTranslate = self.menuContainer.frame.width * 0.8
                let yTranslate = self.menuContainer.frame.height * 0.8
                
                var reportButtonTransform = CGAffineTransform(translationX: -xTranslate, y: -yTranslate)
                reportButtonTransform = CGAffineTransform(scaleX: 0.85, y: 0.85).concatenating(reportButtonTransform)
                self.reportButton.transform = reportButtonTransform
                
                var wikiButtonTransform = CGAffineTransform(translationX: 0, y: -yTranslate * 1.5)
                wikiButtonTransform = CGAffineTransform(scaleX: 0.85, y: 0.85).concatenating(wikiButtonTransform)
                self.wikiButton.transform = wikiButtonTransform
                
                var placeButtonTransform = CGAffineTransform(translationX: xTranslate, y: -yTranslate)
                placeButtonTransform = CGAffineTransform(scaleX: 0.85, y: 0.85).concatenating(placeButtonTransform)
                self.placeButton.transform = placeButtonTransform
                
                self.menuContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
        } else {
            UIView.animate(withDuration: animationTime) {
                self.menuContainer.transform = CGAffineTransform.identity
                
                [self.reportButton, self.wikiButton, self.placeButton].forEach({
                    var transform = CGAffineTransform.identity
                    transform = CGAffineTransform(scaleX: 0.1, y: 0.1).concatenating(transform)
                    $0?.transform = transform
                })
            }
        }
    }
    
    @IBAction func reportPressed(_ sender: Any) {
        self.presentPhotoPicker(sourceType: .camera)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    
    //MARK: - Actions Outlets
    @IBAction func centralTapped(_ sender: Any) {
        print("central tapped")
        showingButtons.toggle()
        toggleButtons(show: showingButtons)
    }
    
    @IBAction func addPlacePressed(_ sender: Any) {
        hapticFeedbackManager.impactOccurred(intensity: 0.5)
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add place", message: "Add a place in the current coordinate", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.placeholder = "Place name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if let placeName = textField?.text,
                placeName != "" {
                let newPlace = SceneLocation(name: placeName, location: self.currentLocation!.coordinate, image: nil)
                self.sceneDatabase.addScene(scene: newPlace)
            }
            
            self.hapticNotificationManager.notificationOccurred(.success)
        }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.hapticNotificationManager.notificationOccurred(.error)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func wikiTapped(_ sender: Any) {
        hapticFeedbackManager.impactOccurred(intensity: 0.5)
    }
    
    @IBAction func reportTapped(_ sender: Any) {
        hapticFeedbackManager.impactOccurred(intensity: 0.5)
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
            logger.log(message: "Success: has permission")
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        case .denied, .restricted:
            // Location services not authorised, stop tracking the user.
            logger.log(message: "Can't track, boohoo")
            locationManager?.stopUpdatingLocation()
            mapView.showsUserLocation = false
            currentLocation = nil
            
        default:
            // Location services pending authorisation.
            // Alert requesting access is visible at this point.
            logger.log(message: "Ok just requesting")
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
        annotationView?.image = UIImage(named: "signal-place-pdf")?.resized(withPercentage: resizeSize)
        //        annotationView?.clusteringIdentifier = "place"
    }
    
    func createSceneResolvedAnnotationView(_ annotationView: MKAnnotationView?) {
        annotationView?.image = UIImage(named: "signal-blue-pdf")?.resized(withPercentage: resizeSize)
        annotationView?.subviews.filter({ $0.tag == -333 }).forEach({ $0.removeFromSuperview() })
    }
    
    fileprivate func createCircleView(withSize size: CGRect, backgroundColor: UIColor, andStroke strokeWidth: CGFloat, withColor color: UIColor) -> UIView {
        
        let frameWidth = max(size.width, size.height)
        
        let view = UIView(frame: CGRect(x: -size.width/1.75, y: size.height/2.5, width: frameWidth, height: frameWidth))
        
        view.backgroundColor = backgroundColor
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = strokeWidth
        
        view.layer.cornerRadius = frameWidth/2
        
        view.tag = -333
        
        return view
    }
    
    fileprivate func createPulse(in annotationView: MKAnnotationView?, withColor color: UIColor, andMaxScale scale: CGFloat, repeatingEach duration: Double ) {
        let circleView = createCircleView(withSize: annotationView!.frame, backgroundColor: color, andStroke: 1, withColor: .clear)
        
        circleView.isUserInteractionEnabled = false
        annotationView?.addSubview(circleView)
        
        circleView.alpha = 0.7
        circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: duration, delay: 1, options: [.repeat], animations: {
            circleView.alpha = 0
            circleView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { (_) in
            circleView.alpha = 0.7
            circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
    }
    
    fileprivate func createSceneThreatAnnotationView(_ sceneInfo: SceneLocation, _ annotationView: MKAnnotationView?) {
        if sceneInfo.threatLevel == 0 {
            //            annotationView?.clusteringIdentifier = "signal-beta-pdf"
            annotationView?.image = UIImage(named: "signal-beta-pdf")?.resized(withPercentage: resizeSize)
            
            createPulse(in: annotationView, withColor: .systemYellow, andMaxScale: 1, repeatingEach: 1.5)
            
        } else if sceneInfo.threatLevel == 1 {
            //            annotationView?.clusteringIdentifier = "signal-alpha-pdf"
            annotationView?.image = UIImage(named: "signal-alpha-pdf")?.resized(withPercentage: resizeSize)
            
            
            createPulse(in: annotationView, withColor: .systemOrange, andMaxScale: 1, repeatingEach: 1.5)
            createPulse(in: annotationView, withColor: .systemOrange, andMaxScale: 1.5, repeatingEach: 1.5)
        } else {
            //            annotationView?.clusteringIdentifier = "signal-omega-pdf"
            annotationView?.image = UIImage(named: "signal-omega-pdf")?.resized(withPercentage: resizeSize)
            
            
            createPulse(in: annotationView, withColor: .systemRed, andMaxScale: 1, repeatingEach: 1.5)
            createPulse(in: annotationView, withColor: .systemRed, andMaxScale: 1.5, repeatingEach: 1.5)
            createPulse(in: annotationView, withColor: .systemRed, andMaxScale: 2, repeatingEach: 1.5)
        }
    }
    
    fileprivate func createCalloutView(_ annotation: SceneLocationAnnotation) -> SceneCalloutView {
        let customView = UINib(nibName: "SceneCalloutView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! SceneCalloutView
        
        let calloutViewFrame = customView.frame
        
        customView.frame = CGRect(x: -calloutViewFrame.size.width/2.5, y: -calloutViewFrame.size.height-3, width: 300, height: 250)
        
        customView.setup(sceneLocation: annotation.sceneLocation)
        customView.controller = self
        
        customView.isUserInteractionEnabled = true
        return customView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self),
            let annotation = annotation as? SceneLocationAnnotation else {
                return nil
        }
        
        let sceneLocation = annotation.sceneLocation
        
        var annotationIdentifier = "annotationPlace"
        if sceneLocation.type == .scene {
            if sceneLocation.threatLevel == 0 {
                annotationIdentifier = "annotationBeta"
            } else if sceneLocation.threatLevel == 1 {
                annotationIdentifier = "annotationAlpha"
            } else {
                annotationIdentifier = "annotationOmega"
            }
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKCustomAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            
            let customView = createCalloutView(annotation)
            customView.annotationView = annotationView
            
            annotationView!.detailCalloutAccessoryView = customView
            annotationView!.canShowCallout = true
            
            
            if sceneLocation.type == .place {
                createPlaceAnnotationView(annotationView)
            } else if sceneLocation.type == .scene {
                if sceneLocation.sceneResolved! {
                    createSceneResolvedAnnotationView(annotationView)
                } else {
                    createSceneThreatAnnotationView(sceneLocation, annotationView)
                }
            }
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let parentCalloutView = view.subviews.first,
                let backgroundCalloutView = parentCalloutView.subviews.first,
                let firstLayer = backgroundCalloutView.layer.sublayers?.first {
                firstLayer.opacity = 0
                backgroundCalloutView.backgroundColor = .lightBackground
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        //        for childView in view.subviews{
        //            childView.removeFromSuperview()
        //        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    // MARK: - MapKitGoogleStyler
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "MapDarkStyle", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay)
    }
    
}

extension Notification.Name {
    static let mapScenesUpdate = Notification.Name("mapScenesUpdate")
}
