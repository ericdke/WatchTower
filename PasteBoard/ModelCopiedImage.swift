//
//  ModelCopiedImage.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 23/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

// An object for the newly copied image.
// Compared by content.
struct CopiedImage: Hashable, Equatable, CustomStringConvertible {
    
    // Date and time of copy.
    let date:Date
    
    // The copied image.
    let content:NSImage
    
    // The active application when the image was copied.
    let source:Application
    
    init(content: NSImage, source: Application, date: Date = Date()) {
        self.date = date
        self.content = content
        self.source = source
    }
    
    var description: String {
        return "\"\(content.description)\" - \(source.name) - \(date)"
    }
    
    var hashValue: Int {
        return content.hashValue
    }
    
}
