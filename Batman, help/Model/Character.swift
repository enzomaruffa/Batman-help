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
    var name: String
    var type: CharacterType
    var assetName: String
    
    var powerstats: CharacterPowerstats
    var fullName: String
    var height: Int
    var weight: Int
    
    var baseLocation: String
    
    var occupation: String?
    
    internal init(id: Int, name: String, type: CharacterType, assetName: String, powerstats: CharacterPowerstats, fullName: String = "Unknown", height: Int, weight: Int, baseLocation: String, occupation: String?) {
        self.id = id
        self.name = name
        self.type = type
        self.assetName = assetName
        self.powerstats = powerstats
        self.fullName = fullName
        self.height = height
        self.weight = weight
        self.baseLocation = baseLocation
        self.occupation = occupation
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
}
