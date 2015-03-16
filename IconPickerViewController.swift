//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/16/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}

class IconPickerViewController: UITableViewController {
        
    weak var delegate: IconPickerViewControllerDelegate?
        
    // A list of the names of the icon images added to the Images.xcassets
    let icons = [ "No Icon", "StartOverIcon", "SmallIcon", "SliderTrackLeft", "SliderTrackRight"]
    /* 
    Uncomment this one and delete the one above when the true images are put in the Images.xcassets "folder"
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
    */
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return icons.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as UITableViewCell
        let iconName = icons[indexPath.row]
        
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            if let delegate = delegate {
            
                let iconName = icons[indexPath.row]
            
                delegate.iconPicker(self, didPickIcon: iconName)
            }
        }
        
        
        
        
}