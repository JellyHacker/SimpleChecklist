//
//  Checklist.swift
//  Checklists
//
//  Created by Brandon Evans on 3/9/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import UIKit

class Checklist: NSObject {
   
    var name = ""
    
    init(name: String) {
        
        self.name = name
        super.init()
    }
}
