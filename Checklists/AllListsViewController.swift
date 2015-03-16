//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/9/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    var lists: [Checklist]
    
    required init(coder aDecoder: NSCoder) {
        
        lists = [Checklist]()
        super.init(coder: aDecoder)
        //println(documentsDirectory())
        loadChecklists()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = lists[indexPath.row]
        
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checklist = lists[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        // This will make it so the title of the checklist is the name of the checklist
        if segue.identifier == "ShowChecklist" {
        
            let controller = segue.destinationViewController as ChecklistTableViewController
        
            controller.checklist = sender as Checklist
        } else if segue.identifier == "AddChecklist" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPaths = [indexPath]
        
        lists.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        //Inside this method you create the view controller object for the Add/Edit Checklist screen and show it (“present” it) on the screen.
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        let controller = navigationController.topViewController as ListDetailViewController
        let checklist = lists[indexPath.row]
        
        controller.delegate = self
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    /*
        ListDetailViewControllerDelegate methods
    */
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        
        let newRowIndex = lists.count
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        lists.append(checklist)
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        
        if let index = find(lists, checklist) {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                cell.textLabel?.text = checklist.name
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
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
    func saveChecklists() {
    
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
    
        // First you put the results of [self dataFilePath] in a temporary constant named path. You use the pathname more than once in this method so having it available in a local instead of calling dataFilePath() several times over is a small optimization.
        let path = dataFilePath()
    
        // Then you check whether the file actually exists and decide what happens based on that. If there is no Checklists.plist then there are obviously no ChecklistItem objects to load. This is what happens when the app is started up for the very first time. In that case, you’ll skip the rest of this method.
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
    
            //When the app does find a Checklists.plist file, you’ll load the entire array and its contents from the file. This is essentially the reverse of saveChecklistItems(). First you load the contents of the file into an NSData object. Because this may fail, you put it in an if let statement. Then you create an NSKeyedUnarchiver object (note: this is an unarchiver) and ask it to decode that data into the items array. This populates the array with exact copies of the ChecklistItem objects that were frozen into this file.
            if let data = NSData(contentsOfFile: path) {
    
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
    
                lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
                unarchiver.finishDecoding()
            }
        
        }
    
    }

    
    
    
    
    
    
    
    
    
}













