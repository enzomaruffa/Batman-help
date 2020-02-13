//
//  SceneLocation.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import MapKit
import CloudKit

class SceneLocation {
    
    var recordId: CKRecord.ID? = nil
    
    let character: Int?
    let threatLevel: Int?
    var sceneResolved: Bool? = false
    
    let name: String?
    let image: UIImage?
    
    let location: CLLocationCoordinate2D
    let creationDate: Date
    let type: SceneLocationType
    
    internal init(character: Int?, threatLevel: Int, location: CLLocationCoordinate2D, image: UIImage) {
        self.character = character
        self.threatLevel = threatLevel
        self.name = nil
        self.location = location
        self.creationDate = Date()
        self.type = .scene
        self.image = image
    }
    
    internal init(name: String, location: CLLocationCoordinate2D, image: UIImage?) {
        self.character = nil
        self.threatLevel = nil
        
        self.name = name
        self.location = location
        self.creationDate = Date()
        self.type = .place
        self.image = image
    }
    
    internal init(character: Int?, threatLevel: Int?, name: String?, location: CLLocationCoordinate2D, creationDate: Date, type: SceneLocationType, image: UIImage?, recordId: CKRecord.ID?) {
        self.character = character
        self.threatLevel = threatLevel
        self.name = name
        self.location = location
        self.creationDate = creationDate
        self.type = type
        self.image = image
        
        self.recordId = recordId
    }
    
}
