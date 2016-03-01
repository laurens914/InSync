//
//  Event.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation
import CloudKit


class Event
{
    var eventName: String
    var eventDate: String
   var recordId: CKRecordID
    
    init(eventName:String, eventDate: String, recordId: CKRecordID)
    {
        self.eventName = eventName
        self.eventDate = eventDate
        self.recordId = recordId
    }

}