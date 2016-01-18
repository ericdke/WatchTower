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
    
    // Instance of the pasteboard monitor ("watcher").
    // Contains the polling timer, known apps, the active app, and of courses the copied strings.
    let watcher = PasteboardWatcher.sharedInstance
    
    // A delegate method called by the watcher. Conforms to PasteboardWatcherDelegate.
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
        if let content = NSUserDefaults().objectForKey("CopiedStrings") as? [String:[AnyObject]] {
            for (copiedString, items) in content {
                if let bundle = items[0] as? String,
                    name = items[1] as? String,
                    date = items[2] as? Int {
                    let aa = ActiveApp(name: name, bundleID: bundle)
                    let d = NSDate(timeIntervalSince1970: NSTimeInterval(date))
                    watcher.copiedStrings.append(CopiedString(date: d, content: copiedString, source: aa))
                    watcher.knownApps.insert(KnownApp(activeApp: aa))
                }
            }
            watcher.copiedStrings.sortInPlace { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 }
        }
        
        self.watcher.delegate = self
        // Start watching the general pasteboard.
        self.watcher.startPolling()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        let strings = NSMutableDictionary()
        for app in watcher.copiedStrings {
            strings[app.content] = NSArray(array: [app.source.bundleID, app.source.name, Int(app.date.timeIntervalSince1970)])
        }
        NSUserDefaults().setObject(strings, forKey: "CopiedStrings")
    }


}

