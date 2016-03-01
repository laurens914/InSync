//
//  CloudKit.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/26/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation
import CloudKit

//typealias CloudCompletion = (success: Bool) -> ()
//
//class Cloud
//{
//    static let shared = Cloud()
//    
//    let container: CKContainer
//    let database: CKDatabase
//    
//    private init ()
//    {
//        self.container = CKContainer.defaultContainer()
//        self.database = self.container.privateCloudDatabase
//        
//    }
//    
//    func POST(post: Event, completion: CloudCompletion)
//    {
//        do {
//            if let record = try Event.recordWith(post) {
//                self.database.saveRecord(record, completionHandler: { (record, error) -> Void in
//                    if error == nil {
//                        print(record)
//                        completion(success:true)
//                    }
//                    
//                })
//                
//            }
//        } catch let error {print(error)}
//    }
//    func getPosts(completion:(posts: [Post]?) -> ())
//    {
//        let query = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
//        self.database.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
//            if error == nil {
//                if let records = records {
//                    var posts = [Post]()
//                    for record in records {
//                        guard let asset = record["image"] as? CKAsset else {return}
//                        guard let path = asset.fileURL.path else {return}
//                        guard let image = UIImage(contentsOfFile: path) else {return}
//                        posts.append(Post(image:image))
//                    }
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        completion (posts: posts)
//                    })
//                }
//            } else {
//                print(error)
//            }
//        }
//    }
//}