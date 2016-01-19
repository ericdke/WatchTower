//
//  PBWProtocols.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

protocol PasteboardWatcherDelegate {

    // A delegate for when a String has been copied.
    func newlyCopiedStringObtained(copied: CopiedString)
    
    // A delegate method for when any app becomes active.
    func anAppDidBecomeActive(app: ActiveApp)
    
}

