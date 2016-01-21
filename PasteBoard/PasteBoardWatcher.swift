//
//  PasteBoardWatcher.swift
//  PasteBoard
//
//  Created by Eric D. on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

class PasteboardWatcher: NSObject {
    
    // This class is a Singleton.
    static let sharedInstance = PasteboardWatcher()
    
    private let pasteboard = NSPasteboard.generalPasteboard()
    
    var delegate: PasteboardWatcherDelegate?
    
    // Keep track of the changes in the pasteboard.
    private var changeCount: Int
    
    // Used to regularly poll the pasteboard for changes.
    private var timer: NSTimer?
    
    // A set of applications we've already copied from.
    var knownApps = Set<Application>()
    
    // The current active application.
    var activeApp:Application?
    
    // Applications we won't copy from.
    var forbiddenApps = [Application(name: "1Password", bundleID: "com.agilebits.onepassword-osx")]
    
    // The collection of copied strings.
    let copiedStrings = CopiedStringsCollection()
    
    override init() {
        // On launch, we mirror the pasteboard context.
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
                let aa = Application(name: name, bundleID: bundle)
                activeApp = aa
                knownApps.insert(aa)
                if let delegate = delegate {
                    delegate.anAppDidBecomeActive(aa)
                } else {
                    print("ERROR The PBDelegate didn't work.")
                }
                
        }
    }
    
    // Regularly polls the general pasteboard to see if there's been changes.
    // Not very pretty, but even Apple does it like this, so let's go.
    func startPolling() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "checkForChangesInPasteboard", userInfo: nil, repeats: true)
    }
    
    // Called by the timer.
    // If there's been a change in the general pasteboard:
    // - Appends new strings to "copiedStrings"
    // - Calls the delegate
    // Has to be marked @objc because it's private *and* called by NSTimer.
    @objc private func checkForChangesInPasteboard() {
        if pasteboard.changeCount != changeCount {
            if let copiedString = pasteboard.stringForType(NSPasteboardTypeString),
                active = activeApp {
                    let st = CopiedString(date: NSDate(), content: copiedString, source: active)
                    copiedStrings.append(st)
                    if let delegate = delegate {
                        delegate.newlyCopiedStringObtained(st)
                    } else {
                        print("ERROR The PBDelegate didn't work.")
                    }
            }
            changeCount = pasteboard.changeCount
        }
    }
}