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
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeObject(checked, forKey: "Checked")
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as String
        // The commented-out code below is what is listed in the tutorial, but doesn't work.  This next line works and does the same thing.
        checked = aDecoder.decodeObjectForKey("Checked") as Bool
        //checked = aDecoder.decodeBoolForKey("Checked")
        super.init()
    }
    
    override init() {
    
        super.init()
    }
    
}
