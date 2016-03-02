//
//  AddTaskViewController.swift
//  InSync
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
        myRecord.setObject(taskNotes.text, forKey: "Date")
        myRecord.setObject(CKReference(recordID: (event?.recordId)!,action: CKReferenceAction.DeleteSelf), forKey: "Event")
        myRecord.setObject(isCompleted.notComplete.hashValue, forKey: "IsCompleted")
        
        if let  publicDatabase = publicDatabase{
            publicDatabase.saveRecord(myRecord, completionHandler:
                ({returnRecord, error in
                    if let error  = error {
                        print(error)
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.record = myRecord
                    }
                }))
        }
    }
//    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var taskNotes: UITextField!
    @IBOutlet weak var dismiss: UIButton!
    @IBOutlet weak var add: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publicDatabase = container.publicCloudDatabase
        
//        self.taskDatePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        let bgColor = CAGradientLayer().gradientBackground()
        bgColor.frame = self.view.bounds
        self.view.layer.insertSublayer(bgColor, atIndex: 0)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.buttonSetup()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        taskText.endEditing(true)
        taskNotes.endEditing(true)
    }
    
//    func datePickerChanged(datePickerEvent: UIDatePicker)
//    {
//        let dateFormatter = NSDateFormatter()
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//        
//        let strDate = dateFormatter.stringFromDate(datePickerEvent.date)
//        taskDate.text = strDate
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func buttonSetup()
    {
        add.layer.cornerRadius = 15
        add.layer.borderWidth = 1
        add.layer.borderColor = UIColor.whiteColor().CGColor
        dismiss.layer.cornerRadius = 15
        dismiss.layer.borderWidth = 1
        dismiss.layer.borderColor = UIColor.whiteColor().CGColor
    }
}



extension CAGradientLayer {
    func gradientBackground() -> CAGradientLayer
    {
        let beginningColor = UIColor(red: 29/255, green: 119/255, blue:239/255, alpha: 1.0).CGColor
        let endingColor = UIColor(red: 129/255, green: 243/255, blue: 253/255, alpha: 1.0).CGColor
        let colorsArray = [beginningColor, endingColor]
        let glayer = CAGradientLayer()
        glayer.colors = colorsArray
        glayer.locations = [0.0, 1.0]
        return glayer
        
    }
}