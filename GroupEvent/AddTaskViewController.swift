//
//  AddTaskViewController.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

class AddTaskViewController: UIViewController
{
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var record: CKRecord?
    var reference: CKReference?
    var event: Event?
    
   static func id() -> String
    {
       return "AddTaskViewController"
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addTask(sender: AnyObject) {
      
        let myRecord = CKRecord(recordType: "Task")
        myRecord.setObject(taskText.text, forKey: "Task")
        myRecord.setObject(taskDate.text, forKey: "Date")
        myRecord.setObject(CKReference(recordID: (event?.recordId)!,action: CKReferenceAction.DeleteSelf), forKey: "Event")
        myRecord.setObject(isCompleted.notComplete.hashValue, forKey: "IsCompleted")
        
        if let  publicDatabase = publicDatabase{
            publicDatabase.saveRecord(myRecord, completionHandler:
                ({returnRecord, error in
                    if let err = error {
                        self.notifyUser("Save Error", message:
                            err.localizedDescription)
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.notifyUser("Success",
                                message: "Record saved successfully")
                        }
                        self.record = myRecord
                    }
                }))
        }
    }
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var taskText: UITextField!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicDatabase = container.publicCloudDatabase
        
        self.taskDatePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        taskText.endEditing(true)
        taskDate.endEditing(true)
    }
    
    func datePickerChanged(datePickerEvent: UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePickerEvent.date)
        taskDate.text = strDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func notifyUser(title: String, message: String) -> Void
    {
        let alert = UIAlertController(title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK",
            style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true,
            completion: nil)
    }
}