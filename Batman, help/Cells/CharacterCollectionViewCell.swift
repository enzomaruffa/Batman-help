//
//  CharacterCollectionViewCell.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 11/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterAlignment: UILabel!
    
    @IBOutlet weak var cellContainer: UIView!
    
    var character: Character!
    
    func setupCell(with character: Character) {
        self.character = character
        
        self.characterImage.image = UIImage(named: character.assetName)
//        self.characterName.text = character.name
        self.characterName.attributedText = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 20)!)
        self.characterAlignment.text = character.type.rawValue
        
        self.cellContainer.layer.cornerRadius = 4
        
//        if character.type == .villain {
//            self.characterName.textColor = UIColor.neon
//        } else {
//            self.characterName.textColor = UIColor.neonRed
//        }
        
    }
}
