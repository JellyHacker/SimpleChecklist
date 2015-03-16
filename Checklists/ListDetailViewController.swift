//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/10/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController,
                                                            didFinishAddingChecklist checklist: Checklist)
    func listDetailViewController(controller: ListDetailViewController,
                                                            didFinishEditingChecklist checklist: Checklist)
    
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "Folder"
    
    @IBAction func cancel() {
        
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        // Checklist already exists --> Editing
        if let checklist = checklistToEdit {
            
            checklist.name = textField.text
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        }
        // Checklist does not already exist --> Adding
        else {
            
            let checklist = Checklist(name: textField.text, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1 {
            
            return indexPath
        } else {
            
            return nil
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destinationViewController as IconPickerViewController
            controller.delegate = self
        }
    }
    
    // Delegate method
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        
        // This puts the name of the chosen icon into the iconName variable to remember it, and also updates the image view with the new image.
        //You don’t call dismissViewController() here but popViewControllerAnimated() because the Icon Picker is on the navigation stack.
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    

}
