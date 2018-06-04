//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jason Feibelman on 6/3/18.
//  Copyright © 2018 Feibel. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        print(Realm.Configuration.defaultConfiguration.fileURL) // Where Realm Database is located
        
//        let data = Data()

        do {
            let _ = try Realm()
        } catch {
            print("Error Initializing new Realm \(error)")
        }
        
        return true
    }
}

