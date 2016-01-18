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
    
    let watcher = PasteboardWatcher()
    
    func newlyCopiedStringObtained(copied: CopiedString) {
        print(copied.source)
        print(copied.date)
        print(copied.content)
        print(watcher.copiedStrings)
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.watcher.delegate = self
        self.watcher.startPolling()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

