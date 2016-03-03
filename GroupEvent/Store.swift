//
//  Store.swift
//  In Sync
//
//  Created by Lauren Spatz on 3/3/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation


class Store
{
    static let shared = Store()
    private init ()
    {
        if let database = NSKeyedUnarchiver.unarchiveObjectWithFile(String.savePath()) as? Set<String> {
            self.database = database
        }
    }
    
    private var database = Set<String>()
    
    func addId(string: String) -> Bool
    {
        self.database.insert(string)
        return self.save()
    }
    
    func ids() -> Set<String>
    {
        return self.database
    }
    
    private func save () -> Bool
    {
        let archivePath = String.savePath()
        return NSKeyedArchiver.archiveRootObject(self.database, toFile: archivePath)
        
    
    }
}