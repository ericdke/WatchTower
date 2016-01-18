//
//  ModelKnownApp.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// An application that has been seen while ours is running.
struct KnownApp: Hashable, Equatable {
    
    var name:String
    
    var bundleID:String
    
    var hashValue:Int {
        return bundleID.hashValue
    }
    
    init(name: String, bundleID: String) {
        self.name = name
        self.bundleID = bundleID
    }
    
    init(activeApp: ActiveApp) {
        self.name = activeApp.name
        self.bundleID = activeApp.bundleID
    }
}

func ==(lhs: KnownApp, rhs: KnownApp) -> Bool {
    return lhs.hashValue == rhs.hashValue
}