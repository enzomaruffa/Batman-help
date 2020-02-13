//
//  CharacterPowerstats.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 11/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

class CharacterPowerstats {
    
    let intelligence: Int
    let strengh: Int
    let speed: Int
    let durability: Int
    let power: Int
    let combat: Int
    
    internal init(intelligence: Int, strengh: Int, speed: Int, durability: Int, power: Int, combat: Int) {
        self.intelligence = intelligence
        self.strengh = strengh
        self.speed = speed
        self.durability = durability
        self.power = power
        self.combat = combat
    }
}
