//
//  Checklist.swift
//  Checklists
//
//  Created by Brandon Evans on 3/9/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//


import UIKit


class Checklist: NSObject, NSCoding {
   
//TODO: Get rid of the :String? once the save bug is fixed
    var name: String? = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        
        self.name = name
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        
//TODO: Get rid of the ? after "as" once the save bug is fixed
        name = aDecoder.decodeObjectForKey("Name") as? String
        items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: "Names")
        aCoder.encodeObject(items, forKey: "Items")
    }
}
