//
//  PasteBoardWatcher.swift
//  PasteBoard
//
//  Created by Eric D. on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

class PasteboardWatcher: NSObject {
    
    static let sharedInstance = PasteboardWatcher()
    
    private let pasteboard = NSPasteboard.generalPasteboard()
    
    private var changeCount: Int
    
    private var timer: NSTimer?
    
    var knownApps = Set<KnownApp>()
    
    var activeApp:ActiveApp?
    
    var copiedStrings = [CopiedString]()
    
    var delegate: PasteboardWatcherDelegate?
    
    override init() {
        self.changeCount = pasteboard.changeCount
        super.init()
        // Registers if any application becomes active (or comes frontmost) and calls a method if it's the case.
        NSWorkspace.sharedWorkspace().notificationCenter.addObserver(self, selector: "activeApp:", name: NSWorkspaceDidActivateApplicationNotification, object: nil)
    }
    
    // Called by NSWorkspace when any application becomes active or comes frontmost.
    func activeApp(sender: NSNotification) {
        if let info = sender.userInfo,
            content = info[NSWorkspaceApplicationKey],
            tn = content.localizedName,
            name = tn,
            tb = content.bundleIdentifier,
            bundle = tb {
                let aa = ActiveApp(name: name, bundleID: bundle)
                activeApp = aa
                knownApps.insert(KnownApp(activeApp: aa))
        }
    }
    
    // Regularly polls the general pasteboard to see if there's been changes.
    // Not very pretty, but this is how Apple do it themselves, so...
    func startPolling() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "checkForChangesInPasteboard", userInfo: nil, repeats: true)
    }
    
    // Called by the timer.
    // If there's been a change in the general pasteboard:
    // - Appends new strings to "copiedStrings"
    // - Calls the delegate
    @objc private func checkForChangesInPasteboard() {
        if pasteboard.changeCount != changeCount {
            if let copiedString = pasteboard.stringForType(NSPasteboardTypeString),
                active = self.activeApp {
                    let st = CopiedString(date: NSDate(), content: copiedString, source: active)
                    copiedStrings.append(st)
                    self.delegate?.newlyCopiedStringObtained(st)
            }
            self.changeCount = pasteboard.changeCount
        }
    }
}