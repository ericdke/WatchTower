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
    var date:NSDate
    
    // The copied String.
    var content:String
    
    // The active application when the String was copied. 
    var source:Application
    
    var description: String {
        return "\"\(content)\" - \(source.name) - \(date)"
        
    }
}