//
//  CloudKitManager.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 10/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudKitManager: DatabaseAccess {
    
    // MARK: Singleton
    static let shared = CloudKitManager()
    
    // MARK: Variables
    let logger = ConsoleDebugLogger.shared
    
    // MARK: iCloud Variables
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: Initializers
    private init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    
    // MARK: - CloudKit Record Manipulations
    fileprivate func persistRecord(_ record: CKRecord) {
        publicDB.save(record) { (savedRecord, error) in
            if error == nil {
                self.logger.log(message: "Record saved")
            } else {
                self.logger.log(message: "Record not  saved")
            }
        }
    }
    
    fileprivate func createSceneLocationRecord(scene: SceneLocation) {
        
        let record = CKRecord(recordType: "SceneLocation")
        
        record.setValue(scene.character, forKey: "character")
        record.setValue(scene.creationDate, forKey: "creationDate")
        record.setValue(scene.location, forKey: "location")
        record.setValue(scene.name, forKey: "name")
        record.setValue(scene.sceneResolved, forKey: "sceneResolved")
        record.setValue(scene.type.rawValue, forKey: "type")
        record.setValue(scene.image, forKey: "image")


        logger.log(message: "Persisting \(record)")
        
        persistRecord(record)
    }
    
    private func retrieveCharacterRecord(_ callback: @escaping ([CKRecord]?) -> Void) {
           let predicate = NSPredicate(value: true)
           let query = CKQuery(recordType: "Character", predicate: predicate)
           
           logger.log(message: "Performing query...")
           publicDB.perform(query,
                             inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
                               self?.logger.log(message: "Query in progress")
                               guard let self = self else { return }
                               
                               if let error = error {
                                   self.logger.log(message: "Error: \(error.localizedDescription)")
                                   return
                               }
                               
                               // Check if it exists in the remote container
                               guard let results = results else {
                                   self.logger.log(message: "Returning nil!")
                                   callback(nil)
                                   return
                               }
                               self.logger.log(message: "Results found :)")
                               callback(results)
           }
       }
    
    private func retrieveSceneLocations(_ callback: @escaping ([CKRecord]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "SceneLocation", predicate: predicate)
        
        logger.log(message: "Performing query...")
        publicDB.perform(query,
                          inZoneWith: CKRecordZone.default().zoneID) { [weak self] results, error in
                            self?.logger.log(message: "Query in progress")
                            guard let self = self else { return }
                            
                            if let error = error {
                                self.logger.log(message: "Error: \(error.localizedDescription)")
                                return
                            }
                            
                            // Check if it exists in the remote container
                            guard let results = results else {
                                self.logger.log(message: "Returning nil!")
                                callback(nil)
                                return
                            }
                            self.logger.log(message: "Results found :)")
                            callback(results)
        }
    }
    
    fileprivate func createMatchHistoryRecord(characterId: Int,
                                              name: String,
                                              location: CLLocationCoordinate2D,
                                              sceneResolved: Bool,
                                              creationDate: Date,
                                              type: SceneLocationType) {
        let record = CKRecord(recordType: "SceneLocation")
        
        record.setValue(characterId, forKey: "characterId")
        record.setValue(name, forKey: "name")
        record.setValue(location, forKey: "location")
        record.setValue(sceneResolved, forKey: "sceneResolved")
        record.setValue(creationDate, forKey: "creationDate")
        record.setValue(type, forKey: "type")
        
        logger.log(message: "Persisting \(record)")
        
        persistRecord(record)
    }
    
    // MARK: DatabaseAccess Methods
    func getAllCharacters(_ closure: @escaping ([Character]) -> ()) {
        
        retrieveCharacterRecord { charactersRecords in
            // Returns an empty list if it fails
            guard charactersRecords != nil else { return closure([]) }
            
            var characters: [Character] = []
            for characterRecord in charactersRecords! {
                let characterId = characterRecord["id"] as! Int
                let typeString = characterRecord["type"] as! String
                
                guard let type = CharacterType(rawValue: typeString) else { return closure([]) }
                
                let name = characterRecord["id"] as! String
                let assetName = characterRecord["id"] as! String
                let occupation = characterRecord["id"] as! String
                
                let character = Character(id: characterId, type: type, name: name, assetName: assetName, occupation: occupation)
                characters.append(character)
            }
            
            closure(characters)
        }
    }
    
    func getAllScenes(_ closure: @escaping ([SceneLocation]) -> ()) {
        
        retrieveSceneLocations { scenesRecords in
            // Returns an empty list if it fails
            guard scenesRecords != nil else { return closure([]) }
            
            var scenes: [SceneLocation] = []
            for sceneRecord in scenesRecords! {
                let sceneCharacterId = sceneRecord["id"] as! Int?
                let name = sceneRecord["name"] as! String?
                let location = sceneRecord["id"] as! CLLocationCoordinate2D
                let sceneResolved = sceneRecord["id"] as! Bool
                let creationDate = sceneRecord["id"] as! Date
                let image = sceneRecord["image"] as! UIImage
                
                let typeString = sceneRecord["type"] as! String
                guard let type = SceneLocationType(rawValue: typeString) else { return closure([]) }
                
                let sceneLocation = SceneLocation(character: sceneCharacterId, name: name, location: location, creationDate: creationDate, type: type, image: image)
                sceneLocation.sceneResolved = sceneResolved
                
                scenes.append(sceneLocation)
            }
            
            closure(scenes)
        }
        
    }
    
    func addScene(scene: SceneLocation) {
        logger.log(message: "Attempting to add scene")
        
        self.logger.log(message: "Creating record...")
        self.createSceneLocationRecord(scene: scene)
    
    }
    
}
