//
//  PBWProtocols.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

protocol PasteboardWatcherDelegate {

    // A delegate for when a String has been copied.
    func newlyCopiedStringObtained(copied: CopiedString)
    
    // A delegate method for when any app becomes active.
    func anAppBecameActive(app: Application)
    
}

protocol PBTableViewDelegate {
    
    func anObjectWasCopied()
    
}

protocol RepresentsAnApplication {
    
    var name: String { get set }
    
    var bundleID: String  { get set }
    
    var icon: NSImage?  { get set }
    
    var hashValue: Int { get }
    
}

extension RepresentsAnApplication {
    
    var hashValue: Int {
        return bundleID.hashValue
    }
    
    var description: String {
        return "\(name) - \(bundleID)"
    }
    
}