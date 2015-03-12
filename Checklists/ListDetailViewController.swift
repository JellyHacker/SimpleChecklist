//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Brandon Evans on 3/10/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewController(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController,
                                                            didFinishAddingChecklist checklist: Checklist)
    func listDetailViewController(controller: ListDetailViewController,
                                                            didFinishEditingChecklist checklist: Checklist)
    
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    @IBAction func cancel() {
        
        delegate?.listDetailViewController(self)
    }
    
    @IBAction func done() {
        
        // Checklist already exists --> Editing
        if let checklist = checklistToEdit {
            
            checklist.name = textField.text
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        }
        // Checklist does not already exist --> Adding
        else {
            
            let checklist = Checklist(name: textField.text)
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    
    
    
    
    
    
    

}
