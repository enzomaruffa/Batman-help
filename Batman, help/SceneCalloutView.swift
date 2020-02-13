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
    
    var database: DatabaseAccess = Singleton.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(sceneLocation: SceneLocation) {
        
        database.getAllCharacters({ characters in
            
            let character = characters.filter({ $0.id == sceneLocation.character }).first!
            
            
            var color = UIColor.neon
            
            if sceneLocation.threatLevel == 0 {
                color = .threatYellow
            } else if sceneLocation.threatLevel == 1 {
                color = .threatOrange
            } else if sceneLocation.threatLevel == 2 {
                color = .threatRed
            }
            
            
            DispatchQueue.main.async {
                self.threatAlertLabel.textColor = color
                
                let string = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 15)!)
                
                self.villainNameLabel.attributedText = string
                
                self.villainImageView.image = UIImage(named: character.assetName)
                
                self.calendarImage.tintColor = color
                
                self.resolvedButton.titleLabel?.textColor = color
                self.resolvedButton.layer.borderColor = color.cgColor
                self.resolvedButton.layer.borderWidth = 1
                self.resolvedButton.layer.cornerRadius = 4
            }
            
        })
        
        
        
        
    }
    
}
