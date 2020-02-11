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
    
    func setupCell(character: Character) {
        self.character = character
        
        self.characterImage.image = UIImage(named: character.assetName)
        self.characterName.text = character.name
        self.characterAlignment.text = character.type.rawValue
        
    }
}
