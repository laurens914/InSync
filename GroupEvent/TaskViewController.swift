//
//  TaskViewController.swift
//  InSync
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
    var refreshControl: UIRefreshControl!
    let checkedImage = UIImage(named: "sample-1040-checkmark")
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    static func id() -> String
    {
        return "TaskViewController"
    }
    var event: Event?
  
    var taskList = [Task](){
        didSet{
            self.taskList.sortInPlace { (taskOne, taskTwo) -> Bool in
                return taskOne.taskName.compare(taskTwo.taskName, options:.CaseInsensitiveSearch, range: nil, locale: nil) == .OrderedAscending
            }
            self.taskTableView.reloadData()
            activitySpinner.stopAnimating()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTasks()
        activitySpinner.startAnimating()
        activitySpinner.hidesWhenStopped = true
        self.setupTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        publicDatabase = container.publicCloudDatabase
        self.prefersStatusBarHidden()
        self.taskTableView.separatorColor = UIColor.clearColor()
        self.taskButtonSetup()
      
    }
    
    func setupTable()
    {
        self.taskTableView.estimatedRowHeight = 100
        self.taskTableView.rowHeight = UITableViewAutomaticDimension
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
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func taskButtonSetup()
    {
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        dismissButton.layer.cornerRadius = 15
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddTaskViewController.id() {
            guard let addTaskViewController = segue.destinationViewController as? AddTaskViewController else {
                fatalError("oops...") }
            addTaskViewController.event = self.event
            addTaskViewController.dismiss = {
                self.dismissViewControllerAnimated(true, completion: nil)
                if let record = addTaskViewController.record {
                self.taskList.append(Task(
                taskName:record.objectForKey("Task") as! String,
                taskDate:record.objectForKey("Date") as? String,
                reference: record.objectForKey("Event") as! CKReference,
                    taskId:record.objectForKey("recordID") as! CKRecordID, completed:isCompleted.notComplete))
             }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskCell = self.taskTableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskTableViewCell
        let taskRow = self.taskList[indexPath.row]
    
        switch taskRow.completed{
        case .notComplete:
            taskCell.completedButtonState.setBackgroundImage(UIImage(named: "box"), forState: .Normal)
            
        case .completed:
            taskCell.completedButtonState.setBackgroundImage(UIImage(named: "checkmark"), forState: .Normal)
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
            let currentTaskRecord = self.taskList[indexPath.row].taskId
            self.taskList.removeAtIndex(indexPath.row)
            self.taskTableView.reloadData()
            if let publicDatabase = publicDatabase{
                publicDatabase.deleteRecordWithID(currentTaskRecord, completionHandler: { (RecordID, error) -> Void in
                    if let error = error {
                        print(error.localizedDescription)
                        let errorAlertController = UIAlertController(title: "Error", message: "please try again", preferredStyle: .Alert)
                        errorAlertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        self.presentViewController(errorAlertController, animated: true, completion: nil)
                        self.updateTasks()
                    }else
                    {
                    print("success")
                    }
                })
            }
        }
    }
        
    func cellColor(indexPath: Int) -> UIColor
    {
        let cellCount = self.taskList.count-1
        let cellCustomeColor = (CGFloat(indexPath)/CGFloat(cellCount)) * 0.7
        return UIColor(red: 29/255, green: cellCustomeColor, blue:239/255, alpha: 0.8)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = cellColor(indexPath.row)
    }
}
 