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
    let image: UIImage?
    let location: CLLocationCoordinate2D
    var sceneResolved = false
    let creationDate: Date
    let type: SceneLocationType
    
    internal init(character: Int?, location: CLLocationCoordinate2D, image: UIImage) {
        self.character = character
        self.name = nil
        self.location = location
        self.creationDate = Date()
        self.type = .scene
        self.image = image
    }
    
    internal init(name: String, location: CLLocationCoordinate2D, image: UIImage?) {
        self.character = nil
        self.name = name
        self.location = location
        self.creationDate = Date()
        self.type = .place
        self.image = image
    }
    
    internal init(character: Int?, name: String?, location: CLLocationCoordinate2D, creationDate: Date, type: SceneLocationType, image: UIImage?) {
        self.character = character
        self.name = name
        self.location = location
        self.creationDate = creationDate
        self.type = type
        self.image = image
    }
    
}
