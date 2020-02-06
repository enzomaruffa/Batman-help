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
    let location: CLLocationCoordinate2D
    let sceneResolved = false
    let creationDate: Date
    
    internal init(character: Character?, location: CLLocationCoordinate2D) {
        self.character = character
        self.location = location
        self.creationDate = Date()
    }
}
