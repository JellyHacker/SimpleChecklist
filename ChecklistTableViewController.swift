//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/3/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checklist: Checklist!
    var items: [ChecklistItem]
    
    required init(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = false
        items.append(row4item)
        
        super.init(coder: aDecoder)
        loadChecklistItems()
        
        // Save folder and path information
        /*
        println("Documents folder is \(documentsDirectory())")
        println("Data file path is \(dataFilePath())")
        */
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        let item = items[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        
        label.text = item.text
        
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPaths = [indexPath]
        
        items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        saveChecklistItems()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Add Item" {
            // The storyboard shows that the segue does not go directly to ItemDetailViewController but to the navigation controller that embeds it. So first you get ahold of this UINavigationController object
            let navigationController = segue.destinationViewController as UINavigationController
            
            // To find the ItemDetailViewController, you can look at the navigation controller’s topViewController property. This property refers to the screen that is currently active inside the navigation controller
            let controller = navigationController.topViewController as ItemDetailViewController
            
            // Once you have a reference to the ItemDetailViewController object, you set its delegate property to self and the connection is complete. Note that “self” here refers to the ChecklistViewController
            controller.delegate = self
        } else if segue.identifier == "Edit Item"{
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
                // Sets itemToEdit equal to the item in the items array that has the row matching that which was selected in the tableView
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    
        let label = cell.viewWithTag(1001) as UILabel
        
        if item.checked {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
       
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
       
        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItems()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        if let index = find(items, item) {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItems()
    }
    
    func documentsDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    /*
    This method takes the contents of the items array and in two steps converts this to a block of binary data and then writes this data to a file:
    1. NSKeyedArchiver, which is a form of NSCoder that creates plist files, encodes the array and all the ChecklistItems in it into some sort of binary data format that can be written to a file.
    2. That data is placed in an NSMutableData object, which will write itself to the file specified by dataFilePath.
    */
    func saveChecklistItems() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems() {
        
        // First you put the results of [self dataFilePath] in a temporary constant named path. You use the pathname more than once in this method so having it available in a local instead of calling dataFilePath() several times over is a small optimization.
        let path = dataFilePath()
        
        // Then you check whether the file actually exists and decide what happens based on that. If there is no Checklists.plist then there are obviously no ChecklistItem objects to load. This is what happens when the app is started up for the very first time. In that case, you’ll skip the rest of this method.
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
        
            //When the app does find a Checklists.plist file, you’ll load the entire array and its contents from the file. This is essentially the reverse of saveChecklistItems(). First you load the contents of the file into an NSData object. Because this may fail, you put it in an if let statement. Then you create an NSKeyedUnarchiver object (note: this is an unarchiver) and ask it to decode that data into the items array. This populates the array with exact copies of the ChecklistItem objects that were frozen into this file.
            if let data = NSData(contentsOfFile: path) {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            
            items = unarchiver.decodeObjectForKey("ChecklistItems") as [ChecklistItem]
            unarchiver.finishDecoding()
            }
            
        }

    }
  
    
    
    
    
    
    
    
    
    
    
}
