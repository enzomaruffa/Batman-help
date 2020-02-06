//
//  Character.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 05/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

class Character: Identifiable, Equatable {
    
    var id: Int
    var type: CharacterType
    var name: String
    var assetName: String
    var occupation: String
    
    internal init(id: Int, type: CharacterType, name: String, assetName: String, occupation: String) {
        self.id = id
        self.type = type
        self.name = name
        self.assetName = assetName
        self.occupation = occupation
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
}
