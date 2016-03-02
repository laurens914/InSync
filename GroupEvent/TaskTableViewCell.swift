//
//  TaskTableViewCell.swift
//  GroupEvent
//
//  Created by Lauren Spatz on 2/29/16.
//  Copyright © 2016 Lauren Spatz. All rights reserved.
//

import UIKit
import CloudKit

class TaskTableViewCell: UITableViewCell {

    
    let container = CKContainer.defaultContainer()
    var publicDatabase: CKDatabase?
    var record: CKRecord?
    var reference: CKReference?
    var event: Event?

    @IBOutlet weak var completedButtonState: UIButton!
    @IBAction func isCompletedToggle(sender: AnyObject) {
       switch currentTask.completed{
        case .completed:
            completedButtonState.setBackgroundImage(UIImage(named: "sample-1040-checkmark"), forState: .Normal)
            self.currentTask.completed = .notComplete
            self.completedButtonState.backgroundColor = UIColor.greenColor()
            Cloud.shared.updateRecordWithId(self.currentTask.taskId, withIntValues: ["IsCompleted": 1], completion: { (success) -> () in
                if success {
                    print("yay! - task Completed!")
                }
            })
        
            
        case .notComplete:
            
            completedButtonState.setBackgroundImage(UIImage(named: "uncheckedBox"), forState: .Normal)
            self.currentTask.completed = .completed
            self.completedButtonState.backgroundColor = UIColor.redColor()
            Cloud.shared.updateRecordWithId(self.currentTask.taskId, withIntValues: ["IsCompleted": 0], completion: { (success) -> () in
                if success{
                    print("yay! - task NOT Completed!")
                }
            })
        
        
        }
        
    }
    
    
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskText: UILabel!
    
    
    var currentTask : Task!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
