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
    static let shared =  Store()
    private init (){}
    
    private var database: Set<String> = [""]
    
    func addId(string: String)
    {
        self.database.insert(string)
        self.save()
    }
    
    func ids() -> Set<String> 
    {
        return self.database
    }
    
    private func save ()
    {
        let archivePath = String.savePath()
        NSKeyedArchiver.archiveRootObject(self.database, toFile: archivePath)
    
    }
}