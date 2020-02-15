//
//  ReportViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 07/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import Vision
import MapKit
import MapKitGoogleStyler

class ReportViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var crimeImageView: UIImageView!
    @IBOutlet weak var crimeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeVillainButton: UIButton!
    @IBOutlet weak var threatSegmented: UISegmentedControl!
    @IBOutlet weak var threatLevelLabel: UILabel!
    
    // MARK: - Variables
    var crimeImage: UIImage!
    var currentLocation: CLLocationCoordinate2D?
    
    var charactersDatabase: DatabaseAccess = Singleton.shared
    var locationsDatabase: DatabaseAccess = CloudKitManager.shared
    
    var currentCharacter: Character?
    
    let hapticManager = HapticManager.shared
    let notificationGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View customizations
        crimeImageView.image = crimeImage
        crimeImageView.layer.cornerRadius = 4
        
        changeVillainButton.layer.borderColor = UIColor.neon.cgColor
        changeVillainButton.layer.borderWidth = 1
        changeVillainButton.layer.cornerRadius = 4
        
        let font = UIFont(name: "BatmanForeverAlternate", size: 16)
        threatSegmented.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        updateClassifications(for: crimeImage)
        
        setupMapKit()
    }
    
    // MARK: - CoreML Setup
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: Few_filters___v3().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    // MARK: - CoreML
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else { return }
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                self.crimeLabel.text = "Hmmm, probably no villain is here. We should send it anyway!"
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
                
                let firstVillainClassification = topClassifications.first!
                
                let villainChance = firstVillainClassification.confidence
                
                var currentCharacterName =  firstVillainClassification.identifier.replacingOccurrences(of: "_", with: " ")
                if currentCharacterName == "Two Face" {
                    currentCharacterName = "Two-Face"
                }
                
                
                self.charactersDatabase.getAllCharacters { (characters) in
                    guard let character = characters.filter({ $0.name == currentCharacterName }).first else { return }
                    
                    self.currentCharacter = character
                    
                    let characterName = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 18)!)
                    
                    let font = UIFont(name: "BatmanForeverAlternate", size: 14)!
                    let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white]
                    
                    let chance = villainChance * 100
                    
                    let firstPartAttributed = NSMutableAttributedString(string: "\(chance.rounded())%\n", attributes: attributes)
                    let lastPartAttributed = NSMutableAttributedString(string: "\nis here!", attributes: attributes)
                    
                    firstPartAttributed.append(characterName)
                    firstPartAttributed.append(lastPartAttributed)
                    
                    self.crimeLabel.attributedText = firstPartAttributed
                    
                }
            }
        }
    }
    
    // MARK: - Action Outlets
    @IBAction func sendPressed(_ sender: Any) {
        
        guard let location = currentLocation,
            let id = currentCharacter?.id else { return }
        
        let threatLevel = threatSegmented.selectedSegmentIndex
        let scene = SceneLocation(character: id, threatLevel: threatLevel, location: location, image: crimeImage)
        locationsDatabase.addScene(scene: scene)
        
        notificationGenerator.notificationOccurred(.success)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func threatLevelChanged(_ sender: Any) {
        let currentOption = threatSegmented.selectedSegmentIndex
        
        print(currentOption)
        
        if currentOption == 0 {
            UIView.animate(withDuration: 0.4) {
                self.threatSegmented.selectedSegmentTintColor = .systemYellow
            }
            hapticManager.playAlert(count: 1)
        } else if currentOption == 1 {
            UIView.animate(withDuration: 0.4) {
                self.threatSegmented.selectedSegmentTintColor = .systemOrange
            }
            hapticManager.playAlert(count: 2)
        } else if currentOption == 2 {
            UIView.animate(withDuration: 0.4) {
                self.threatSegmented.selectedSegmentTintColor = .systemRed
            }
            hapticManager.playAlert(count: 3)
        }
    }
    
    // MARK: - MapKit
    
    func setupMapKit() {
        
        let location = currentLocation ?? CLLocationCoordinate2D(latitude: -25.452767,
                                                                 longitude: -49.249728)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        configureTileOverlay()
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
