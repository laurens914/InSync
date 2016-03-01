//
//  AddEventViewController.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/23/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.


import UIKit
import CloudKit

class AddEventViewController: UIViewController
{
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var record: CKRecord?
    var postedURL: NSURL?
    
    @IBOutlet weak var eventDateText: UITextField!
    @IBOutlet weak var datePickerEvent: UIDatePicker!
    @IBOutlet weak var eventText: UITextField!
    @IBAction func addEvent(sender: AnyObject) {
        
        let myRecord = CKRecord(recordType: "Event")
        myRecord.setObject(eventText.text, forKey: "Event")
        myRecord.setObject(eventDateText.text, forKey: "Date")
        myRecord.setObject(NSUUID().UUIDString, forKey: "Id")
        
        
        if let  publicDatabase = publicDatabase{
            publicDatabase.saveRecord(myRecord, completionHandler:
                ({returnRecord, error in
                    if let error = error {
                        print(error)
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                          print("success")
                        self.record = myRecord
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                    }
                }))
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        publicDatabase = container.publicCloudDatabase
        
        self.datePickerEvent.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
                eventText.endEditing(true)
                eventDateText.endEditing(true)
    }
    
    func datePickerChanged(datePickerEvent: UIDatePicker)
    {
    let dateFormatter = NSDateFormatter()
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    let strDate = dateFormatter.stringFromDate(datePickerEvent.date)
    eventDateText.text = strDate
    }
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if self.eventDateText.isFirstResponder() {
            self.eventDateText.resignFirstResponder()
        }
        if self.eventText.isFirstResponder(){
            self.eventText.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        eventText.center.x -= view.bounds.width
    }
    
 
}

