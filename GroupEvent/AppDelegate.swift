//
//  AppDelegate.swift
//  InSync
//
//  Created by Lauren Spatz on 2/19/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var publicDatabase: CKDatabase?
    var ckRecord: CKRecord?
    let container = CKContainer.defaultContainer()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        publicDatabase = container.publicCloudDatabase
        let urlString = String(url)
        let components = urlString.componentsSeparatedByString("=")
        if let id = components.last  {
            Store.shared.addId(id)
        }
      
        Cloud.shared.addInvitedEvent(Store.shared.ids()) { (events) -> () in
            print("success")
            print(events)
        }
        
        return true
        
    }
    
}

