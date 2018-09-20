//
//  AppDelegate.swift
//  KLMDemo
//
//  Created by Atul Kumar on 9/10/18.
//  Copyright © 2018 Atul Kumar. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreDataManager = CoreDataManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataManager.saveContext()
    }
    
}

