//
//  PBWProtocols.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

protocol PasteboardWatcherDelegate {
    func newlyCopiedStringObtained(copied: CopiedString)
}

