//
//  TaskDo.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import Foundation
protocol TaskDo: class
{
    typealias Tasks: Task
    
    var taskList: [Tasks] {get set}
    
    func addTask(task: Tasks)
    func clearTask(task: Tasks)
    func clearList()
    func count() -> Int
    func removeObjectAtIndexPath(index: Int)
    func objectAtIndex(index: Int) -> Tasks?
    func viewList() -> [Tasks]
    
    
}

extension TaskDo
{
    func addEvent(event: Tasks)
    {
        self.taskList.append(event)
    }
    
    func clearEvent(event: Tasks)
    {
        //
    }
    
    func clearList()
    {
        self.taskList.removeAll()
    }
    
    func count() -> Int
    {
        return self.taskList.count
    }
    
    func removeObjectAtIndexPath(index: Int)
    {
        self.taskList.removeAtIndex(index)
    }
    
    func objectAtIndex(index: Int) -> Tasks?
    {
        return self.taskList[index]
    }
    
    func viewList() -> [Tasks]
    {
        return self.taskList
    }
}