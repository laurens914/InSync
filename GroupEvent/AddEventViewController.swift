//
//  AddEventViewController.swift
//  InSync
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
    
    
  
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var eventDateText: UITextField!
    @IBOutlet weak var datePickerEvent: UIDatePicker!
    @IBOutlet weak var eventText: UITextField!
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

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
                        }
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.record = myRecord
                       
                        
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
        let bgColor = CAGradientLayer().gradientBackground()
        bgColor.frame = self.view.bounds
        self.view.layer.insertSublayer(bgColor, atIndex: 0)
        self.buttonSetup()

    }

    func buttonSetup()
    {
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
}



