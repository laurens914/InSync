//
//  EventDo.swift
//  InSync
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation

protocol EventDo: class
{
    typealias Events: Event, NSCoding 
    
    var eventList: [Events] {get set}
    
    func addEvent(event: Events)
    func clearEvent(event: Events)
    func clearList()
    func removeObjectAtIndexPath(index: Int)
    func objectAtIndex(index: Int) -> Events?
    func viewList() -> [Events]
    func save()
    

}

extension EventDo
{
   func addEvent(event: Events)
   {
    self.eventList.append(event)
    self.save()
    }
    
    func clearEvent(event: Events)
    {
        //
    }
    
    func clearList()
    {
        self.eventList.removeAll()
    }
    
    
    func removeObjectAtIndexPath(index: Int)
    {
        self.eventList.removeAtIndex(index)
    }
    
    func objectAtIndex(index: Int) -> Events?
    {
        return self.eventList[index]
    }
    
    func viewList() -> [Events]
    {
        return self.eventList
    }
    func save()
    {
        NSKeyedArchiver.archiveRootObject(self.eventList, toFile: String.savePath())
    }
    
}