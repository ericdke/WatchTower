//
//  ModelCopiedString.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// An object for the newly copied strings.
// Compared by content.
struct CopiedString: Hashable, Equatable, CustomStringConvertible {
    
    // Date and time of copy.
    let date:Date
    
    // The copied String.
    let content:String
    
    // The active application when the String was copied. 
    let source:Application
    
    // If the content contains URLs, this array will be populated.
    let URLs: [URL]
    
    init(content: String, source: Application, date: Date = Date()) {
        self.date = date
        self.content = content
        self.source = source
        self.URLs = content.extractURLs()
    }
    
    var description: String {
        return "\"\(content)\" - \(source.name) - \(date)"
    }
    
    var hashValue: Int {
        return content.hashValue
    }
    
    
    
}

