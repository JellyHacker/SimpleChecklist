//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/9/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    var dataModel: DataModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            
            let checklist = dataModel.lists[index]
            
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataModel.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        
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
        
        dataModel.lists.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        //Inside this method you create the view controller object for the Add/Edit Checklist screen and show it (“present” it) on the screen.
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        let controller = navigationController.topViewController as ListDetailViewController
        let checklist = dataModel.lists[indexPath.row]
        
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
        
        let newRowIndex = dataModel.lists.count
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        dataModel.lists.append(checklist)
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        
        if let index = find(dataModel.lists, checklist) {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                cell.textLabel?.text = checklist.name
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    // UINavigationControllerDelegate method
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    
    
    
    
    
}













