//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/5/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController,
                                didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    var itemToEdit: ChecklistItem?
    var dueDate =  NSDate()
    var datePickerVisible = false
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    @IBAction func cancel() {
        
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            return indexPath
        } else {
            
            return nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Check whether this is the index-path for the row with the date picker. If not, jump to step 5.
        if indexPath.section == 1 && indexPath.row == 2 {
            
            // Ask the table view whether it already has the date picker cell. If not, then create a new one. The selection style is .None because you don’t want to show a selected state for this cell when the user taps it.
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                // Create a new UIDatePicker component. It has a tag (100) so you can easily find this date picker later.
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                cell.contentView.addSubview(datePicker)
                /*
                Tell the date picker to call the method dateChanged() whenever the user picks a new date. You have seen how to connect action methods from Interface Builder; this is how you do it from code.
                You put the name of the method inside a string. The : after the name signifies that dateChanged() takes a single parameter, which will be a reference to the UIDatePicker.
                The Selector() thingie tells Swift that this isn’t a normal string but the name of a method. Now the UIDatePicker’s Value Changed event triggers the dateChanged() method (you’ll add this method soon).
                */
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
            
            return cell
        }
            // For any index-paths that are not the date picker cell, call through to super (which is UITableViewController). This is the trick that makes sure the other static cells still work.
            else {
            
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisible {
        
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
        
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
        
            showDatePicker()
        }
    }
    
    // Necessary when overwriting static table cells because you are changing the data source of the table
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 2 {
        
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.length > 0 {
            doneBarButton.enabled = true
        } else {
            doneBarButton.enabled = false
        }
        
        return true
    }
    
    func updateDueDateLabel() {
        
        let formatter = NSDateFormatter()
        
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        
        datePickerVisible = true
        
        let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    }
    
    // For the due date picker
    func dateChanged(datePicker: UIDatePicker) {
        
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
}

