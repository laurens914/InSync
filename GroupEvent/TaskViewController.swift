//
//  TaskViewController.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

class TaskViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Id
{
    var publicDatabase: CKDatabase?
    var ckRecord: CKRecord?
    let container = CKContainer.defaultContainer()
    let checkedImage = UIImage(named: "sample-1040-checkmark")
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var taskTableView: UITableView!

    static func id() -> String
    {
        return "TaskViewController"
    }
    var event: Event?
  
    var taskList = [Task](){
        didSet{
            self.taskTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        publicDatabase = container.publicCloudDatabase
        self.updateTasks()
    }
    func updateTasks()
    {
        if let event = event {
        Cloud.shared.getTasksWithEventId(event.recordId) { (tasks) -> () in
            if let tasks = tasks
            {
                self.taskList = tasks
            }
        }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddTaskViewController.id() {
            guard let addTaskViewController = segue.destinationViewController as? AddTaskViewController else {
                fatalError("oops...") }
            addTaskViewController.event = self.event
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskCell = self.taskTableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskTableViewCell
        let taskRow = self.taskList[indexPath.row]
    
        switch taskRow.completed{
        case .notComplete:
            taskCell.completedButtonState.setBackgroundImage(UIImage(named: "sample-1040-checkmark"), forState: .Normal)
            taskCell.completedButtonState.backgroundColor = UIColor.greenColor()
            
        case .completed:
            taskCell.completedButtonState.setBackgroundImage(UIImage(named: "uncheckedBox"), forState: .Normal)
            taskCell.completedButtonState.backgroundColor = UIColor.redColor()
        }
        
        taskCell.currentTask = taskRow
        
        taskCell.taskText.text = taskRow.taskName
        taskCell.taskDate.text = taskRow.taskDate
        
        return taskCell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let publicDatabase = publicDatabase{
                publicDatabase.deleteRecordWithID(taskList[indexPath.row].taskId, completionHandler: { (RecordID, error) -> Void in
                    if let error = error {
                        print(error)
                    }else
                    {
                    print("success")
                    self.updateTasks()
                    }
                })
            }
        }
    }

}
 