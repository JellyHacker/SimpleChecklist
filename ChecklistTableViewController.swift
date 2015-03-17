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
    var items: [ChecklistItem] = []
    
    /*
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
    */
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
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        let item = checklist.items[indexPath.row]
        let label = cell.viewWithTag(1000) as UILabel
        
        label.text = item.text
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPaths = [indexPath]
        
        checklist.items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
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
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    
        let label = cell.viewWithTag(1001) as UILabel
        
        label.textColor = view.tintColor
        
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
       
        let newRowIndex = checklist.items.count
        
        checklist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        if let index = find(checklist.items, item) {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
}
