//
//  AppDelegate.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    fileprivate func checkForNotificationPermission(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("D'oh: \(error.localizedDescription)")
                } else {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "BatmanForeverAlternate", size: 15)!
        ], for: .normal)
    
        self.checkForNotificationPermission(application)
        UNUserNotificationCenter.current().delegate = self
        
        // Check if cloudkit subscriptions exists
        checkSubscription { (exists) in
            if !exists {
                self.createSubscription()
            }
        }
        
        return true
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    
    fileprivate func createSubscription() {
        let predicate = NSPredicate(format:"threatLevel = 2")
        let subscription = CKQuerySubscription(recordType: "SceneLocation", predicate: predicate, options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "WATCH OUT! A new threat alert has been issued!"
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        let database = CKContainer.default().publicCloudDatabase
        database.save(subscription) { result, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkSubscription(_ closure: @escaping (Bool) -> ()) {
        let database = CKContainer.default().publicCloudDatabase
        database.fetchAllSubscriptions { [unowned self] subscriptions, error in
            if error == nil {
                if let subscriptions = subscriptions,
                    subscriptions.count > 0 {
                    closure(true)
                    // more code to come!
                } else {
                    closure(false)
                }
            } else {
                print(error!.localizedDescription)
                closure(false)
            }
        }
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

