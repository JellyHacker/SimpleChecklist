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
        
        var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
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



}

    
    
    
    
    
    
    
    
    
    
    

