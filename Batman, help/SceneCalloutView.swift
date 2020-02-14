//
//  SceneCalloutView.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 13/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class SceneCalloutView: UIView {
    
    @IBOutlet weak var threatAlertLabel: UILabel!
    @IBOutlet weak var villainNameLabel: UILabel!
    @IBOutlet weak var villainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var resolvedButton: UIButton!
    
    var characterDatabase: DatabaseAccess = Singleton.shared
    var sceneDatabase: DatabaseAccess = CloudKitManager.shared
    var sceneLocation: SceneLocation!
    
    weak var controller: UIViewController?
    
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
            
            let character = characters.filter({ $0.id == sceneLocation.character }).first!
            
            var color = UIColor.white
            
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
                    
                    let string = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 15)!)
                    
                    self.villainNameLabel.attributedText = string
                    
                    self.villainImageView.image = UIImage(named: character.assetName)
                    
                    self.calendarImage.tintColor = color
                    
                    self.resolvedButton.titleLabel?.textColor = color
                    self.resolvedButton.layer.borderColor = color.cgColor
                    self.resolvedButton.layer.borderWidth = 1
                    self.resolvedButton.layer.cornerRadius = 4
                    
                    if sceneLocation.sceneResolved ?? false {
                        self.resolvedButton.isHidden = true
                        self.threatAlertLabel.text = "PAST THREAT"

                    }
                })
            }
            
        })
        
        
        
        
    }
    
    @IBAction func resolvedTapped(_ sender: Any) {
        let title = "MARK AS SOLVED"
        let message = "MARK AS SOLVED"

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.sceneLocation.sceneResolved = true
            self.sceneDatabase.updateScene(self.sceneLocation)
            
            self.setup(sceneLocation: self.sceneLocation)
        }))
        ac.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        controller?.present(ac, animated: true)
    }
}
