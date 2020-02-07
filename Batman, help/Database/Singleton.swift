//
//  CharacterSingleton.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 05/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation
import MapKit

class Singleton: DatabaseAccess {
    
    static var shared = Singleton()
    
    var characters: [Character] = []
    var sceneLocations: [SceneLocation] = []
    
    private init() {
        
        // Create base characters
        var character = Character(id: 1, type: .hero, name: "Batman", assetName: "batman", occupation: "Businessman")
        characters.append(character)
        character = Character(id: 2, type: .hero, name: "Robin", assetName: "robin", occupation: "Businessman")
        characters.append(character)
        character = Character(id: 3, type: .villain, name: "Joker", assetName: "joker", occupation: "Mad man")
        characters.append(character)
        character = Character(id: 4, type: .villain, name: "Two Faces", assetName: "two-faces", occupation: "Deputy")
        characters.append(character)
        
        
        var location = CLLocationCoordinate2D(latitude: -25.452767, longitude: -49.249728)
        var place = SceneLocation(name: "Bat-Academy", location: location)
        sceneLocations.append(place)
        
        
        location = CLLocationCoordinate2D(latitude: -25.352767, longitude: -49.249728)
        place = SceneLocation(name: "Local 1", location: location)
        sceneLocations.append(place)
        
        
        location = CLLocationCoordinate2D(latitude: -25.452767, longitude: -49.349728)
        place = SceneLocation(name: "Local 2", location: location)
        sceneLocations.append(place)
        
        location = CLLocationCoordinate2D(latitude: -25.252767, longitude: -49.149728)
        var scene = SceneLocation(character: character, location: location)
        sceneLocations.append(scene)
        
    }
    
    func getAllCharacters(_ closure: ([Character]) -> ()) {
        closure(characters)
    }
    
    func getAllScenes(_ closure: ([SceneLocation]) -> ()) {
        closure(sceneLocations)
    }
    
    func addScene(scene: SceneLocation) {
        sceneLocations.append(scene)
    }
    
}


