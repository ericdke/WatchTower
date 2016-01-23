//
//  ModelCopiedImage.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 23/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

// An object for the newly copied image.
struct CopiedImage: CustomStringConvertible {
    
    // Date and time of copy.
    let date:NSDate
    
    // The copied image.
    let content:NSImage
    
    // The active application when the image was copied.
    let source:Application
    
    init(_ content: NSImage, source: Application, date: NSDate = NSDate()) {
        self.date = date
        self.content = content
        self.source = source
    }
    
    var description: String {
        return "\"\(content.description)\" - \(source.name) - \(date)"
    }
    
}