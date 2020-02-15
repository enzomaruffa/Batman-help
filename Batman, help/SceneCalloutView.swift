//
//  SceneCalloutView.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 13/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import MapKit

class SceneCalloutView: UIView {
    
    @IBOutlet weak var threatAlertLabel: UILabel!
    @IBOutlet weak var villainNameLabel: UILabel!
    @IBOutlet weak var villainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var resolvedButton: UIButton!
    
    @IBOutlet weak var resolvedButtonHeight: NSLayoutConstraint!
    
    var characterDatabase: DatabaseAccess = Singleton.shared
    var sceneDatabase: DatabaseAccess = CloudKitManager.shared
    var sceneLocation: SceneLocation!

    weak var controller: MenuViewController?
    weak var annotationView: MKAnnotationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(sceneLocation: SceneLocation, animated: Bool = false) {
        
        self.layer.cornerRadius = 8
        self.sceneLocation = sceneLocation
        
        characterDatabase.getAllCharacters({ characters in
            
            let character = characters.filter({ $0.id == sceneLocation.character }).first
            
            var color = UIColor.primary
            
            if sceneLocation.sceneResolved != nil {
                if sceneLocation.sceneResolved == true {
                    color = .neon
                } else if sceneLocation.threatLevel == 0 {
                    color = .threatYellow
                } else if sceneLocation.threatLevel == 1 {
                    color = .threatOrange
                } else if sceneLocation.threatLevel == 2 {
                    color = .threatRed
                }
            }
            
            self.resolvedButton.isUserInteractionEnabled = true
            
            DispatchQueue.main.async {
                var animationDuration: Double = 0.0
                if animated {
                    animationDuration = 0.8
                }
                
                UIView.animate(withDuration: animationDuration, animations: {
                    
                    self.threatAlertLabel.textColor = color
                    
                    if let character = character {
                        let string = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 18)!)

                        self.villainNameLabel.attributedText = string
                        
                        self.villainImageView.image = UIImage(named: character.assetName)
                    } else {
                        self.villainNameLabel.text = sceneLocation.name
                        self.villainImageView.image = UIImage(named: "signal-place")
                        self.resolvedButton.isHidden = true
                        self.threatAlertLabel.text = "BAT-PLACE"
                        self.resolvedButtonHeight.constant = 0
                    }
                    

                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    
                    self.dateLabel.text = formatter.string(from: sceneLocation.creationDate)
                    self.calendarImage.tintColor = color
                    
                    self.resolvedButton.setTitleColor(color, for: .normal)
                    self.resolvedButton.layer.borderColor = color.cgColor
                    self.resolvedButton.layer.borderWidth = 1
                    self.resolvedButton.layer.cornerRadius = 4
                    
                    if sceneLocation.sceneResolved ?? false {
                        self.resolvedButton.isHidden = true
                        self.threatAlertLabel.text = "PAST THREAT"
                        self.resolvedButtonHeight.constant = 0
                    }
                })
            }
            
        })
        
        
        
        
    }
    
    @IBAction func resolvedTapped(_ sender: Any) {
        let title = "MARK AS SOLVED?"

        let ac = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.sceneLocation.sceneResolved = true
            self.sceneDatabase.updateScene(self.sceneLocation)
            
            if let annotationView = self.annotationView {
                self.controller?.createSceneResolvedAnnotationView(annotationView)
            }
    
            self.setup(sceneLocation: self.sceneLocation)
        }))
        ac.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        controller?.present(ac, animated: true)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = self.frame.contains(point)
        if !isInside {
            for view in self.subviews {
                let isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
}
