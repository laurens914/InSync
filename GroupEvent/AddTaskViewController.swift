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
    var dismiss:(()->())?
    let bgColor = CAGradientLayer().gradientBackground()

   static func id() -> String
    {
       return "AddTaskViewController"
    }
    
    @IBAction func exitPage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addTask(sender: AnyObject) {
        activitySpinner.startAnimating()
        let myRecord = CKRecord(recordType: "Task")
        myRecord.setObject(taskText.text, forKey: "Task")
        myRecord.setObject(taskNotes.text, forKey: "Date")
        myRecord.setObject(CKReference(recordID: (event?.recordId)!,action: CKReferenceAction.DeleteSelf), forKey: "Event")
        myRecord.setObject(isCompleted.notComplete.rawValue, forKey: "IsCompleted")
        
        if let  publicDatabase = publicDatabase{
            publicDatabase.saveRecord(myRecord, completionHandler:
                ({returnRecord, error in
                    if let error  = error {
                        print(error.localizedDescription)
                    } else {
                        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
                            self.record = myRecord
                            print(self.record)
                            self.dismiss?()
                        }
                     
                    }
                }))
        }
    }
    @IBOutlet weak var taskText: UITextField!
    @IBOutlet weak var taskNotes: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.hidesWhenStopped = true
        activitySpinner.stopAnimating()
        bgColor.frame = self.view.bounds
        publicDatabase = container.publicCloudDatabase
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func buttonSetup()
    {
        add.layer.cornerRadius = 15
        add.layer.borderWidth = 1
        add.layer.borderColor = UIColor.whiteColor().CGColor
        dismissButton.layer.cornerRadius = 15
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.whiteColor().CGColor
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