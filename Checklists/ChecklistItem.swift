//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Brandon Evans on 3/4/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemId: Int
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        // The commented-out code below is what is listed in the tutorial, but doesn't work.  This next line works and does the same thing.
        checked = aDecoder.decodeObjectForKey("Checked") as Bool
        dueDate = aDecoder.decodeObjectForKey("DueDate") as NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemId = aDecoder.decodeIntegerForKey("ItemID")
        //checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
    override init() {
    
        itemId = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            
            //println("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeObject(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemId, forKey: "ItemID")
    }
    
    func scheduleNotification() {
        
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            
            //println("Found an existing notification: \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        /*
        This compares the due date on the item with the current date. You can always get the current time by making a new NSDate object with NSDate().
        The statement dueDate.compare(NSDate()) compares the two dates and returns one
        of the following enum values:
            • NSComparisonResult.OrderedAscending: dueDate comes before the current date and time. In other words, it is in the past.
            • NSComparisonResult.OrderedSame: dueDate is exactly equal to the current date and time (Good luck trying to get this one! You’d have to time it down to the second.)
            • NSComparisonResult.OrderedDescending: dueDate represents a time after the current date and time, so it lies in the future.
        If the due date is in the past, the println() will not be performed.
        */
        if shouldRemind && dueDate.compare(NSDate()) !=
            NSComparisonResult.OrderedAscending {
        
            //println("We should schedule a notification!")
        }
        
        let localNotification = UILocalNotification()
        localNotification.fireDate = dueDate
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = text
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = ["ItemID" : itemId]
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        //println("Scheduled notification \(localNotification) for itemID \(itemId)")
    }
    
    /*
    This asks UIApplication for a list of all scheduled notifications. Then it loops through that list and looks at each notification one-by-one.
    The notification should have an “ItemID” value inside the userInfo dictionary. If that value exists and equals the itemID property, then you’ve found a notification that belongs to this ChecklistItem.
    If none of the local notifications match, or if there aren’t any to begin with, the method returns nil.
    */
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
            
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
            
                if number.integerValue == itemId {
            
                    return notification
                }
            }
        }
        return nil
    }
}


