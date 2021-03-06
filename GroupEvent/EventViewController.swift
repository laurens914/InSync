//
//  ViewController.swift
//  InSync
//
//  Created by Lauren Spatz on 2/19/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var tableView: UITableView!
    
    var event: Event?
    var selectedItem: Event?
    var publicDatabase: CKDatabase?
    var ckRecord: CKRecord?
    let container = CKContainer.defaultContainer()
    var refreshControl: UIRefreshControl!
    let myRecord = CKRecord(recordType: "Event")

    @IBOutlet weak var addButton: UIButton!

    
    var eventList = [Event]()
        {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string:"Loading")
        self.refreshControl.addTarget(self, action: "refreshView:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.refreshControl.backgroundColor = UIColor(red: 29/255, green: 89/255, blue:239/255, alpha: 0.9)
        let ids = Store.shared.ids()
        print(ids.count)
        
        Cloud.shared.addInvitedEvent(ids) { (events, error) -> () in
            guard let events = events else { return }
            for event in events {
                print(event.eventName)
            }
        }
    }

    func refreshView(sender:AnyObject)
    {
       self.update()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.update()
        publicDatabase = container.publicCloudDatabase
        self.tableView.separatorColor = UIColor.clearColor()
        self.navigationController?.navigationBarHidden = true
        self.prefersStatusBarHidden()
        self.update()
        self.addButtonSetup()
    }
    
    func addButtonSetup()
    {
        addButton.layer.cornerRadius = 15
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update()
    {
        Cloud.shared.addInvitedEvent(Store.shared.ids()) { (events, error) -> () in
            if let posts = events {
                self.eventList = posts
            }
            if let error = error {
                print(error)
                self.displayAlertView()
            }
        }
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
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
        eventCell.showsReorderControl = true
        
        return eventCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = eventList[indexPath.row]
        performSegueWithIdentifier("TaskViewController", sender: nil)
    }
    


    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .Normal, title: "Invite") { (action, indexPath) -> Void in
            let text = "Hi! You are invited to join an event. Open with In Sync. Download the app before joining :)    "
            let eventId = self.eventList[indexPath.row].id
            let sharedObjects = [text, "InSync://=\(eventId)"]
                let activityVC = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
                self.presentViewController(activityVC, animated: true, completion: nil)
        }
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            if let publicDatabase = self.publicDatabase{
                publicDatabase.deleteRecordWithID(self.eventList[indexPath.row].recordId, completionHandler: { (RecordID, error) -> Void in
                    if let error = error {
                        print(error)
                    }else { print("success")
                        self.update()}
                })
            }
        }
        return[delete, share]
    }
    
    func cellColor(indexPath: Int) -> UIColor
    {
        let cellCount = self.eventList.count-1
        let cellCustomeColor = (CGFloat(indexPath)/CGFloat(cellCount)) * 0.9
        return UIColor(red: 29/255, green: cellCustomeColor, blue:239/255, alpha: 0.9)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = cellColor(indexPath.row)
    }
    
    func displayAlertView()
    {
        let alertController = UIAlertController(title: "No iCloud Account Found", message: "please sign into your account", preferredStyle: .Alert)
        let settingsAlert = UIAlertAction(title: "Settings", style: .Default) { (alertAction) -> Void in
            if let appSettings = NSURL(string:UIApplicationOpenSettingsURLString){
                UIApplication.sharedApplication().openURL(appSettings)
            }
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        alertController.addAction(settingsAlert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        return
    }
}

