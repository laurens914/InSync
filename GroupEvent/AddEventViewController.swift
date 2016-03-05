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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var eventDateText: UITextField!
    @IBOutlet weak var datePickerEvent: UIDatePicker!
    @IBOutlet weak var eventText: UITextField!
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addEvent(sender: AnyObject) {
        let id = NSUUID().UUIDString
        if Store.shared.addId(id){
            let myRecord = CKRecord(recordType: "Event")
            myRecord.setObject(eventText.text, forKey: "Event")
            myRecord.setObject(eventDateText.text, forKey: "Date")
            myRecord.setObject(id, forKey: "Id")
            myRecord.setObject(eventText.text, forKey: "Name")
            
            if let  publicDatabase = publicDatabase{
                publicDatabase.saveRecord(myRecord, completionHandler:
                    ({returnRecord, error in
                        if let error = error {
                            print(error)
                        } else {
                            NSOperationQueue().addOperationWithBlock{ () -> Void in
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.record = myRecord
                            
                        }
                    }))
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        publicDatabase = container.publicCloudDatabase
        self.datePickerEvent.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.datePickerEvent.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
      
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
                eventText.endEditing(true)
                eventDateText.endEditing(true)
    }
    
    func datePickerChanged(datePickerEvent: UIDatePicker)
    {
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.LongStyle
        let stringDate = dateFormat.stringFromDate(datePickerEvent.date)
        eventDateText.text = stringDate
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



