//
//  ViewController.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/19/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

class EventViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var tableView: UITableView!
    
    var selectedItem: Event?
    var publicDatabase: CKDatabase?
    var ckRecord: CKRecord?
    let container = CKContainer.defaultContainer()
    
    let myRecord = CKRecord(recordType: "Event")
    
    
    

    var eventList = [Event]()
        {
        didSet{
            self.tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        publicDatabase = container.publicCloudDatabase
 
        self.update()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update()
    {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        Cloud.shared.getPosts{ (posts) -> () in
            if let posts = posts {
                self.eventList = posts
                self.navigationItem.leftBarButtonItem = nil
            } else {
                print("no posts")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == TaskViewController.id() {
            guard let taskViewController = segue.destinationViewController as? TaskViewController else {
                fatalError("oops...") }
            taskViewController.event = self.selectedItem
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell = self.tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
        let eventRow = self.eventList[indexPath.row]
        eventCell.textLabel?.text = eventRow.eventName
        eventCell.detailTextLabel?.text = eventRow.eventDate
        return eventCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = eventList[indexPath.row]
        performSegueWithIdentifier("TaskViewController", sender: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let publicDatabase = publicDatabase{
                publicDatabase.deleteRecordWithID(eventList[indexPath.row].recordId, completionHandler: { (RecordID, error) -> Void in
                    if let error = error {
                        print(error)
                    }else { print("success")
                    self.update()}
                })
            }
        }
    }
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        <#code#>
    }
    }

}

