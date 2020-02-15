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
    fileprivate func persistRecord(_ record: CKRecord, _ closure: @escaping () -> ()) {
        publicDB.save(record) { (savedRecord, error) in
            if error == nil {
                self.logger.log(message: "Record saved")
            } else {
                self.logger.log(message: "Record not saved! Error: \(error!.localizedDescription)")
            }
            closure()
        }
    }
    
    
    fileprivate func sendNotificationWithNewScene(_ scene: SceneLocation) {
        let dict: [String: SceneLocation] = ["scene": scene]
        NotificationCenter.default.post(name: .mapScenesUpdate, object: nil, userInfo: dict)
    }
    
    fileprivate func setRecordValues(_ record: CKRecord, scene: SceneLocation) {
        //update your record here
        record.setValue(scene.character, forKey: "character")
        record.setValue(scene.threatLevel, forKey: "threatLevel")
        record.setValue(scene.creationDate, forKey: "date")
        record.setValue(scene.location.latitude, forKey: "latitude")
        record.setValue(scene.location.longitude, forKey: "longitude")
        record.setValue(scene.name, forKey: "name")
        record.setValue(scene.sceneResolved, forKey: "sceneResolved")
        record.setValue(scene.type.rawValue, forKey: "type")
    }
    
    fileprivate func createSceneLocationRecord(scene: SceneLocation) {
        
        let record = CKRecord(recordType: "SceneLocation")
        
        setRecordValues(record, scene: scene)
        
        // Image storing
        var imageUrl: URL?
        if let image = scene.image?.resized(withPercentage: 0.2) {
            let data = image.pngData()
            let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
            imageUrl = url
            do {
                try data!.write(to: url!, options: [])
            } catch let e as NSError {
                print("Error converting image! \(e)");
                return
            }
            record.setValue(CKAsset(fileURL: url!), forKey: "image")
            logger.log(message: "Image URL: \(String(describing: url?.description))")
        }
        
        logger.log(message: "Persisting \(record)")
        
        persistRecord(record) {
            // Removing temporary image
            if let url = imageUrl {
                do { try FileManager.default.removeItem(at: url) }
                catch let e { print("Error deleting temp file: \(e)") }
            }
            
            self.sendNotificationWithNewScene(scene)
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
                            self.logger.log(message: "\(results.count) results found :)")
                            
                            callback(results)
        }
    }
    
    // MARK: DatabaseAccess Methods
    func getAllCharacters(_ closure: @escaping ([Character]) -> ()) {
        closure([])
    }
    
    func getAllScenes(_ closure: @escaping ([SceneLocation]) -> ()) {
        
        retrieveSceneLocations { scenesRecords in
            // Returns an empty list if it fails
            guard scenesRecords != nil else { return closure([]) }
            
            var scenes: [SceneLocation] = []
            for sceneRecord in scenesRecords! {
                let characterId = sceneRecord["character"] as! Int?
                let threatLevel = sceneRecord["threatLevel"] as! Int?
                let name = sceneRecord["name"] as! String?
                let latitude = sceneRecord["latitude"] as! Double
                let longitude = sceneRecord["longitude"] as! Double
                let sceneResolved = sceneRecord["sceneResolved"] as! Bool
                let creationDate = sceneRecord["date"] as! Date
                let image = (sceneRecord["image"] as? CKAsset)?.toUIImage() ?? UIImage()
                
                let typeString = sceneRecord["type"] as! String
                guard let type = SceneLocationType(rawValue: typeString) else { return closure([]) }
                
                let sceneLocation = SceneLocation(character: characterId, threatLevel: threatLevel, name: name, location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), creationDate: creationDate, type: type, image: image, recordId: sceneRecord.recordID)
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
    
    func updateScene(_ scene: SceneLocation) {
        if let recordID = scene.recordId {
            publicDB.fetch(withRecordID: recordID) { record, error in
                
                if let record = record, error == nil {
                    self.setRecordValues(record, scene: scene)
                    
                    // Image storing
                    var imageUrl: URL?
                    if let image = scene.image?.resized(withPercentage: 0.2) {
                        let data = image.pngData()
                        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
                        imageUrl = url
                        do {
                            try data!.write(to: url!, options: [])
                        } catch let e as NSError {
                            print("Error converting image! \(e)");
                            return
                        }
                        record.setValue(CKAsset(fileURL: url!), forKey: "image")
                        self.logger.log(message: "Image URL: \(String(describing: url?.description))")
                    }
                    
                    self.publicDB.save(record) { _, error in
                        // Removing temporary image
                        if let url = imageUrl {
                            do { try FileManager.default.removeItem(at: url) }
                            catch let e { print("Error deleting temp file: \(e)") }
                        }
                    }
                }
            }
        }
    }
    
}

