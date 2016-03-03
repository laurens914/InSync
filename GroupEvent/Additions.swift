//
//  Additions.swift
//  InSync
//
//  Created by Lauren Spatz on 2/26/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation

extension String
{
   static func savePath() -> String
   {
    guard let saved = NSURL.archiveURL().path else { fatalError()}
    
    return saved
    }
}

extension NSURL
{
    class func archiveURL() -> NSURL
    {
        guard let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else { fatalError()}
        return documentsDirectory.URLByAppendingPathComponent("event")
    }
}