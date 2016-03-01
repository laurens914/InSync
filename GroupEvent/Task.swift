//
//  Task.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation
import CloudKit


class Task
{
    var taskName: String
    var taskDate: String
    var event: Event?
    var reference: CKReference
    var taskId: CKRecordID
    var completed: isCompleted
    
    init(taskName: String, taskDate: String, event: Event? = nil, reference: CKReference, taskId: CKRecordID, completed: isCompleted)
    {
        self.taskName = taskName
        self.taskDate = taskDate
        self.event = event
        self.reference = reference
        self.taskId = taskId
        self.completed = completed
    }
}