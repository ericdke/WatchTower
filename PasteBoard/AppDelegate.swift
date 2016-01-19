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
    
    // Singleton instance of the pasteboard monitor (the "watcher").
    // Contains the polling timer, known apps, the active app, and of course the copied strings.
    let watcher = PasteboardWatcher.sharedInstance
    
    // A delegate method for when a String has been copied.
    func newlyCopiedStringObtained(copied: CopiedString) {
        print(copied.source.name)
        print(copied.date)
        print(copied.content)
        print("---")
        print(watcher.copiedStrings.allItems)
        print("---")
        print(watcher.knownApps)
        print("\n***\n")
    }
    
    // A delegate method for when any app becomes active.
    func anAppDidBecomeActive(app: Application) {
        print("Active app: \(app.name) - \(app.bundleID)")
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        // Populate the collection with data from previous run.
        if let content = NSUserDefaults().objectForKey("CopiedStrings") as? [String:[AnyObject]] {
            for (copiedString, items) in content {
                if let bundle = items[0] as? String,
                    name = items[1] as? String,
                    date = items[2] as? Int {
                    let aa = Application(name: name, bundleID: bundle)
                    let d = NSDate(timeIntervalSince1970: NSTimeInterval(date))
                    watcher.copiedStrings.append(date: d, content: copiedString, source: aa)
                    watcher.knownApps.insert(aa)
                }
            }
            watcher.copiedStrings.sortByDate()
        }
        
        // Populate the forbidden applications.
        if let content = NSUserDefaults().objectForKey("ForbiddenApps") as? [String: String] {
            for (bundle, name) in content {
                let app = Application(name: name, bundleID: bundle)
                if !watcher.forbiddenApps.contains(app) {
                    watcher.forbiddenApps.append(app)
                }
            }
        }
        
        watcher.delegate = self
        
        // Start watching the general pasteboard.
        watcher.startPolling()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
        // Record the current copied strings before quitting.
        let strings = NSMutableDictionary()
        for app in watcher.copiedStrings.allItems {
            strings[app.content] = NSArray(array: [app.source.bundleID, app.source.name, Int(app.date.timeIntervalSince1970)])
        }
        NSUserDefaults().setObject(strings, forKey: "CopiedStrings")
        
        // Record the forbidden applications.
        let fapps = NSMutableDictionary()
        for app in watcher.forbiddenApps {
            fapps[app.bundleID] = app.name
        }
        NSUserDefaults().setObject(fapps, forKey: "ForbiddenApps")
    }


}

