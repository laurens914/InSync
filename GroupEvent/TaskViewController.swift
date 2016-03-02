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
  
   
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    var publicDatabase: CKDatabase?
    var ckRecord: CKRecord?
    let container = CKContainer.defaultContainer()
    let checkedImage = UIImage(named: "sample-1040-checkmark")
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
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
        self.prefersStatusBarHidden()
        self.taskTableView.separatorColor = UIColor.clearColor()
        self.taskButtonSetup()
      
    }
//    func setupTable()
//    {
//        self.taskTableView.estimatedRowHeight = 200
//        self.taskTableView.rowHeight = UITableViewAutomaticDimension
//    }
    
    func updateTasks()
    {
        let spin = activitySpinner
        spin.hidesWhenStopped = true
        spin.startAnimating()
        
        if let event = event {
            Cloud.shared.getTasksWithEventId(event.recordId) { (tasks) -> () in
                if let tasks = tasks
                {
                    self.taskList = tasks
                    spin.stopAnimating()
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
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        let completed = UITableViewRowAction(style: .Normal, title: "Completed") { (action, indexPath) -> Void in
//            let completedString = NSMutableAttributedString(string:self.taskList[indexPath.row].taskName)
//            completedString.addAttribute(NSStrikethroughStyleAttributeName, value: 0, range: NSMakeRange(0, completedString.length))
//     
//        }
//        let delete = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
//            if let publicDatabase = self.publicDatabase{
//                publicDatabase.deleteRecordWithID(self.taskList[indexPath.row].taskId, completionHandler: { (RecordID, error) -> Void in
//                    if let error = error {
//                        print(error)
//                    }else { print("success")
//                        self.updateTasks()}
//                })
//            }
//        }
//        return[delete, completed]
//    }
    
    
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
 