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

class ReportViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var crimeImageView: UIImageView!
    @IBOutlet weak var crimeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeVillainButton: UIButton!
    @IBOutlet weak var threatSelector: UISegmentedControl!
    @IBOutlet weak var threatLevelLabel: UILabel!
    
    // MARK: - Variables
    var crimeImage: UIImage!
    var currentLocation: CLLocationCoordinate2D?
    
    var charactersDatabase: DatabaseAccess = Singleton.shared
    var locationsDatabase: DatabaseAccess = CloudKitManager.shared
    
    var currentCharacter: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View customizations
        crimeImageView.image = crimeImage
        crimeImageView.layer.cornerRadius = 4
        
        changeVillainButton.layer.borderColor = UIColor.neon.cgColor
        changeVillainButton.layer.borderWidth = 1
        changeVillainButton.layer.cornerRadius = 4
        
        updateClassifications(for: crimeImage)
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
            let model = try VNCoreMLModel(for: More_Filters___v3().model)
            
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
                
                self.currentCharacter =  firstVillainClassification.identifier.replacingOccurrences(of: "_", with: " ")
                if self.currentCharacter == "Two Face" {
                    self.currentCharacter = "Two-Face"
                }
                
                self.crimeLabel.text = String(format: " I'm %.2f sure that %@ is here!", villainChance, self.currentCharacter!)
            }
        }
    }
    
    // MARK: - Action Outlets
    @IBAction func sendPressed(_ sender: Any) {
        
        guard let location = currentLocation else { return }
        
        var characterId: Int?
        
            if let characterName = currentCharacter {
                charactersDatabase.getAllCharacters { characters in
                let character = characters.filter({ $0.name == characterName }).first!
                characterId = character.id
            }
        }
        
        let threatLevel = threatSelector.selectedSegmentIndex
        let scene = SceneLocation(character: characterId, threatLevel: threatLevel, location: location, image: crimeImage)
        locationsDatabase.addScene(scene: scene)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func threatLevelChanged(_ sender: Any) {
        let currentOption = threatSelector.selectedSegmentIndex
        
        print(currentOption)
        
        if currentOption == 0 {
            UIView.animate(withDuration: 0.4) {
                self.threatSelector.selectedSegmentTintColor = .systemYellow
            }
        } else if currentOption == 1 {
            UIView.animate(withDuration: 0.4) {
                self.threatSelector.selectedSegmentTintColor = .systemOrange
            }
        } else if currentOption == 2 {
            UIView.animate(withDuration: 0.4) {
                self.threatSelector.selectedSegmentTintColor = .systemRed
            }
        }
    }
    
}
