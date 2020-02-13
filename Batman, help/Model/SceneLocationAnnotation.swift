//
//  SceneLocationAnnotation.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 13/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import MapKit

class SceneLocationAnnotation: NSObject, MKAnnotation {
    
    let sceneLocation: SceneLocation
    var coordinate: CLLocationCoordinate2D {
        sceneLocation.location
    }
    
    var subtitle: String? {
        if sceneLocation.type == .place {
            return "KNOWN LOCATION"
        } else {
            switch sceneLocation.threatLevel {
            case 0:
                return "BETA LEVEL THREAT"
            case 1:
                return "ALPHA LEVEL THREAT"
                
            case 2:
                return "OMEGA LEVEL THREAT"
                
            default:
                return "Unknown"
            }
        }
    }
    
    var title: String? {
        if let name = sceneLocation.name {
            return name
        } else if sceneLocation.threatLevel != nil {
            return "ALERT"
        } else {
            return "Unknown location"
        }
    }
    
    internal init(sceneLocation: SceneLocation) {
        self.sceneLocation = sceneLocation
    }
    
}
