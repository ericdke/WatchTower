//
//  ModelActiveApp.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// An active application seen by ours.
struct ActiveApp: Hashable, Equatable {
    var name:String
    var bundleID:String
    var hashValue:Int {
        return bundleID.hashValue
    }
}

func ==(lhs: ActiveApp, rhs: ActiveApp) -> Bool {
    return lhs.hashValue == rhs.hashValue
}