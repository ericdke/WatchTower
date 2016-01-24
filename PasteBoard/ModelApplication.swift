//
//  ModelApplication.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

// An active application seen by ours.
// Compared by bundleID.
struct Application: Hashable, Equatable, CustomStringConvertible, RepresentsAnApplication {
    
    var name: String
    
    var bundleID: String
    
    var icon: NSImage?
    
    init(name: String, bundleID: String) {
        self.name = name
        self.bundleID = bundleID
    }
    
    init(name: String, bundleID: String, icon: NSImage) {
        self.init(name: name, bundleID: bundleID)
        self.icon = icon
    }
}

