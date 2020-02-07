//
//  SceneLocation.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import MapKit

class SceneLocation {
    
    let character: Character?
    let name: String?
    let location: CLLocationCoordinate2D
    let sceneResolved = false
    let creationDate: Date
    let type: SceneLocationType
    
    internal init(character: Character, location: CLLocationCoordinate2D) {
        self.character = character
        self.name = nil
        self.location = location
        self.creationDate = Date()
        self.type = .scene
    }
    
    internal init(name: String, location: CLLocationCoordinate2D) {
        self.character = nil
        self.name = name
        self.location = location
        self.creationDate = Date()
        self.type = .place
    }
}
