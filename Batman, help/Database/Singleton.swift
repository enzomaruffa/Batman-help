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
        
        var powerstats = CharacterPowerstats(intelligence: 88, strengh: 38, speed: 23, durability: 56, power: 51, combat: 96)
        var character = Character(id: 60, name: "Bane", type: .villain, assetName: "character-bane", powerstats: powerstats, height: 203, weight: 180, baseLocation: "Santa Prisca", occupation: nil)
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 88, strengh: 11, speed: 33, durability: 40, power: 34, combat: 90)
        character = Character(id: 60, name: "Batgirl", type: .hero, assetName: "character-batgirl", powerstats: powerstats, fullName: "Barbara Gordon", height: 170, weight: 57, baseLocation: "Gotham City", occupation: nil)
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 100, strengh: 26, speed: 27, durability: 50, power: 47, combat: 100)
        character = Character(id: 70, name: "Batman", type: .hero, assetName: "character-batman", powerstats: powerstats, fullName: "Bruce Wayne", height: 188, weight: 95, baseLocation: "Gotham City", occupation: "Businessman")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 69, strengh: 11, speed: 33, durability: 28, power: 27, combat: 85)
        character = Character(id: 165, name: "Catwoman", type: .hero, assetName: "character-catwoman", powerstats: powerstats, fullName: "Selina Kyle", height: 175, weight: 61, baseLocation: "Gotham City", occupation: "Thief")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 88, strengh: 12, speed: 33, durability: 65, power: 55, combat: 80)
        character = Character(id: 309, name: "Harley Quinn", type: .villain, assetName: "character-harley-quinn", powerstats: powerstats, fullName: "Harley Quinn", height: 170, weight: 63, baseLocation: "Arkham Asylum", occupation: "Psychiatrist")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 100, strengh: 10, speed: 12, durability: 60, power: 43, combat: 70)
        character = Character(id: 370, name: "Joker", type: .villain, assetName: "character-joker", powerstats: powerstats, fullName: "Jack Napier", height: 196, weight: 86, baseLocation: "Arkham Asylum", occupation: nil)
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 88, strengh: 11, speed: 33, durability: 28, power: 36, combat: 100)
        character = Character(id: 491, name: "Nightwing", type: .hero, assetName: "character-nightwing", powerstats: powerstats, fullName: "Dick Grayson", height: 178, weight: 79, baseLocation: "Bludhaven", occupation: "Detective")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 75, strengh: 10, speed: 12, durability: 28, power: 30, combat: 45)
        character = Character(id: 514, name: "Penguin", type: .villain, assetName: "character-penguin", powerstats: powerstats, fullName: "Oswald Chesterfield Cobblepot", height: 157, weight: 79, baseLocation: "Gotham City", occupation: "Trader")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 81, strengh: 14, speed: 21, durability: 40, power: 100, combat: 40)
        character = Character(id: 522, name: "Poison Ivy", type: .villain, assetName: "character-poison-ivy", powerstats: powerstats, fullName: "Pamela Isley", height: 168, weight: 50, baseLocation: "Gotham City", occupation: "Botanist")
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 100, strengh: 10, speed: 12, durability: 14, power: 10, combat: 14)
        character = Character(id: 558, name: "Riddler", type: .villain, assetName: "character-riddler", powerstats: powerstats, fullName: "Edward Nigma", height: 183, weight: 83, baseLocation: "Gotham City", occupation: nil)
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 75, strengh: 25, speed: 27, durability: 28, power: 28, combat: 85)
        character = Character(id: 562, name: "Robin", type: .villain, assetName: "character-robin", powerstats: powerstats, fullName: "Jason Todd", height: 183, weight: 101, baseLocation: "Gotham City", occupation: nil)
        characters.append(character)
        
        powerstats = CharacterPowerstats(intelligence: 88, strengh: 10, speed: 12, durability: 14, power: 9, combat: 28)
        character = Character(id: 678, name: "Two-Face", type: .villain, assetName: "character-two-face", powerstats: powerstats, fullName: "Harvey Dent", height: 183, weight: 82, baseLocation: "Gotham City", occupation: "District Attorney")
        characters.append(character)
        
        // Places creation
        var location = CLLocationCoordinate2D(latitude: -25.452767, longitude: -49.249728)
        var place = SceneLocation(name: "Bat-Academy", location: location, image: nil)
        sceneLocations.append(place)
        
        
        location = CLLocationCoordinate2D(latitude: -25.352767, longitude: -49.249728)
        place = SceneLocation(name: "Local 1", location: location, image: nil)
        sceneLocations.append(place)
        
        
        location = CLLocationCoordinate2D(latitude: -25.452767, longitude: -49.349728)
        place = SceneLocation(name: "Local 2", location: location, image: nil)
        sceneLocations.append(place)
        
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


