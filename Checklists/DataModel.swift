//
//  DataModel.swift
//  Checklists
//
//  Created by Brandon Evans on 3/16/15.
//  Copyright (c) 2015 Vicinity inc. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    init() {
        
        loadChecklists()
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