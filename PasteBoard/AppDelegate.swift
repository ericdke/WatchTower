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
    
    @IBOutlet weak var mainTable: NSTableView!
    
    
    // Singleton instance of the pasteboard monitor (the "watcher").
    // Contains the polling timer, known apps, the active app, and of course the copied strings.
    let watcher = PasteboardWatcher.sharedInstance
    
    func anAppBecameActive(_ app: Application) {
//        print("Active app: \(app.name) - \(app.bundleID)")
    }
    
    func newlyCopiedStringObtained(_ copied: CopiedString) {
        let msg = "\(copied.date) - \(copied.source.name) - \(copied.content.shortVersion(50))"
        print(msg)
        if !copied.URLs.isEmpty {
            print(copied.URLs)
        }
//        print(watcher.copiedStrings.allItems)
//        print("***")
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Recalls the windows positions.
        window.setFrameUsingName("MainWindow")
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Populate the collection with data from previous run.
        if let content = UserDefaults().object(forKey: "CopiedStrings") as? [String:[AnyObject]] {
            for (theString, items) in content {
                if let bundle = items[0] as? String,
                    let name = items[1] as? String,
                    let date = items[2] as? Int {
                    let aa = Application(name: name, bundleID: bundle)
                    let d = Date(timeIntervalSince1970: TimeInterval(date))
                    watcher.copiedStrings.append(CopiedString(theString, source: aa, date: d))
                    watcher.knownApps.insert(aa)
                }
            }
            watcher.copiedStrings.sortCollection()
        }
        
        // Populate the forbidden applications.
        if let content = UserDefaults().object(forKey: "ForbiddenApps") as? [String: String] {
            for (bundle, name) in content {
                let app = Application(name: name, bundleID: bundle)
                if !watcher.forbiddenApps.contains(app) {
                    watcher.forbiddenApps.append(app)
                }
            }
        }

        // Sets self as the delegate for the watcher.
        watcher.delegate = self
        
        // Start watching the general pasteboard.
        watcher.startPolling()
        
        // The table shows previous copied items at launch.
        mainTable.reloadData()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // NSUSerDefaults for now - might need to use NSCoding instead later if we add complexity.
        
        // Record the current copied strings before quitting.
        let strings = NSMutableDictionary()
        for app in watcher.copiedStrings.sortedItems {
            strings[app.content] = NSArray(array: [app.source.bundleID, app.source.name, Int(app.date.timeIntervalSince1970)])
        }
        UserDefaults().set(strings, forKey: "CopiedStrings")
        
        // Record the forbidden applications.
        let fapps = NSMutableDictionary()
        for app in watcher.forbiddenApps {
            fapps[app.bundleID] = app.name
        }
        UserDefaults().set(fapps, forKey: "ForbiddenApps")
        
        // Save the windows positions.
        window.saveFrame(usingName: "MainWindow")
    }


}

