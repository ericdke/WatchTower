//
//  PasteBoardWatcher.swift
//  PasteBoard
//
//  Created by Eric D. on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

protocol PasteboardWatcherDelegate {
    func newlyCopiedStringObtained(copied: CopiedString)
}

struct CopiedString {
    var date:NSDate
    var content:String
    var source:String
}

class PasteboardWatcher: NSObject {
    
    private let pasteboard = NSPasteboard.generalPasteboard()
    
    private var changeCount: Int
    
    private var timer: NSTimer?
    
    var activeAppName = ""
    
    var copiedStrings = [CopiedString]()
    
    var delegate: PasteboardWatcherDelegate?
    
    override init() {
        self.changeCount = pasteboard.changeCount
        super.init()
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "activeApp:", name: NSWorkspaceDidActivateApplicationNotification, object: nil)
    }
    
    func activeApp(sender: NSNotification) {
        if let info = sender.userInfo,
            content = info[NSWorkspaceApplicationKey],
            temp = content.localizedName,
            name = temp {
                self.activeAppName = name
        }
    }
    
    func startPolling() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("checkForChangesInPasteboard"), userInfo: nil, repeats: true)
    }
    
    @objc private func checkForChangesInPasteboard() {
        if pasteboard.changeCount != changeCount {
            if let copiedString = pasteboard.stringForType(NSPasteboardTypeString) {
                    let st = CopiedString(date: NSDate(), content: copiedString, source: self.activeAppName)
                    copiedStrings.append(st)
                    self.delegate?.newlyCopiedStringObtained(st)
            }
            self.changeCount = pasteboard.changeCount
        }
    }
}