//
//  ModelCopiedString.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// An object for the newly copied strings
struct CopiedString: CustomStringConvertible {
    
    // Date and time of copy.
    let date:NSDate
    
    // The copied String.
    let content:String
    
    // The active application when the String was copied. 
    let source:Application
    
    // If the content contains URLs, this array will be populated.
    let URLs: [NSURL]
    
    init(date: NSDate, content: String, source: Application) {
        self.date = date
        self.content = content
        self.source = source
        self.URLs = content.extractURLs()
    }
    
    var description: String {
        return "\"\(content)\" - \(source.name) - \(date)"
    }
    
}