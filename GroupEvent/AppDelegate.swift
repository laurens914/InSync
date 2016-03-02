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
        let recordNameId = urlString.componentsSeparatedByString("=")
        let recordName = recordNameId[1]
        Cloud.shared.addInvitedEvent(recordName) { (events) -> () in
            print("success")
        }
        
        return true
        
    }
    
}

