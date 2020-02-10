//
//  SceneLocation.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import MapKit

class SceneLocation {
    
    let character: Int?
    let name: String?
    let location: CLLocationCoordinate2D
    var sceneResolved = false
    let creationDate: Date
    let type: SceneLocationType
    
    internal init(character: Int, location: CLLocationCoordinate2D) {
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
    
    internal init(character: Int?, name: String?, location: CLLocationCoordinate2D, creationDate: Date, type: SceneLocationType) {
        self.character = character
        self.name = name
        self.location = location
        self.creationDate = creationDate
        self.type = type
    }
    
}
