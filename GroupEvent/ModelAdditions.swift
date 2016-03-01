//
//  ModelAdditions.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/26/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation
import CloudKit

typealias CloudCompletion = (success: Bool) -> ()

enum isCompleted{
    case notComplete
    case completed
}

class Cloud
{
    static let shared = Cloud()
    
    let container: CKContainer
    let database: CKDatabase
    
    
    private init ()
    {
        self.container = CKContainer.defaultContainer()
        self.database = self.container.publicCloudDatabase
        
    }
    
    func getPosts(completion:(events: [Event]?) -> ())
    {
        let query = CKQuery(recordType: "Event", predicate: NSPredicate(value: true))
        self.database.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            
            if error == nil {
                if let records = records {
                    var events = [Event]()
                    for record in records {
                        guard let event = record["Event"] as? String else {return}
                        guard let date = record["Date"] as? String else {return}
                        guard let recordId = record["recordID"] as? CKRecordID else {return}
                        events.append(Event(eventName: event, eventDate: date, recordId: recordId))
                        
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completion (events: events)
                    })
                }
            } else {
                print(error)
            }
        }
    }
    func getTasksWithEventId(eventID: CKRecordID, completion:(tasks: [Task]?) -> ())
    {
        
        let reference = CKReference(recordID: eventID, action: CKReferenceAction.DeleteSelf)
        
        let predicate = NSPredicate(format: "Event==%@", reference)
        
        let query = CKQuery(recordType: "Task", predicate: predicate)
        self.database.performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            
            print(error)
            print(records)
            //        self.database.fetchRecordWithID(eventID, completionHandler: { (records, error) -> Void in
            if error == nil {
                if let records = records {
                    var tasks = [Task]()
                    print(records)
                    for record in records {
                        guard let assetTask = record["Task"] as? String else { print("Task Failed."); return}
                        guard let assetDate = record["Date"] as? String else {print("Date Failed.");return}
                        guard let taskId = record["recordID"] as? CKRecordID else {return}
                        guard let completedInt = record["IsCompleted"] as? Int else { print("Dang it."); return}
                        guard let reference = record["Event"] as? CKReference else { print("Event Failed."); return}
                        
                        var completed : isCompleted!
                        
                        switch completedInt{
                        case 0:
                            completed = isCompleted.notComplete
                        case 1:
                            completed = isCompleted.completed
                        default:
                            print("This is very very bad....")
                        }
                        
                        tasks.append(Task(taskName: assetTask, taskDate: assetDate, reference: reference, taskId: taskId, completed: completed))
                        
                    }
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completion (tasks: tasks)
                    })
                }
            } else {
                print(error)
            }
        }
    }
    
    func updateRecordWithId(recordId: CKRecordID, withIntValues values:[String: Int], completion: (success:Bool) -> ())
    {
     self.database.fetchRecordWithID(recordId) { (record, error) -> Void in
        if let error = error {print(error)}
        guard let record = record else {return}
        for (k,v) in values {
            record[k]=v
        }
        self.database.saveRecord(record, completionHandler: { (record, error) -> Void in
            if let error = error {print(error); completion(success: false)}
            guard let record = record else {completion(success: false); return}
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: true)
            })
        })
        }
        
    }
    
}

















