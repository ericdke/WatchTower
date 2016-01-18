//
//  AppDelegate.swift
//  PasteBoard
//
//  Created by Eric D. on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardWatcherDelegate {

    @IBOutlet weak var window: NSWindow!
    
    // instance of the pasteboard monitor ("watcher")
    // contains the polling timer, known apps, the active app, and of courses the copied strings
    let watcher = PasteboardWatcher()
    
    // a delegate method called by the watcher
    func newlyCopiedStringObtained(copied: CopiedString) {
        print(copied.source.name)
        print(copied.date)
        print(copied.content)
        print("---")
        print(watcher.copiedStrings)
        print("---")
        print(watcher.knownApps)
        print("\n***\n")
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.watcher.delegate = self
        // start watching the general pasteboard
        self.watcher.startPolling()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

