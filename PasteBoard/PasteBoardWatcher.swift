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
    var forbiddenApps = [Application(name: "1Password", bundleID: "com.agilebits.onepassword-osx"),
                         Application(name: "1Pasword mini", bundleID: "2BUA8C4S2C.com.agilebits.onepassword-osx-helper")]
    
    // The collection of copied strings.
    let copiedStrings = CopiedStringsCollection()
    
    // The collection of copied images.
    let copiedImages = CopiedImagesCollection()
    
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
            _name = content.localizedName, _bundle = content.bundleIdentifier,
            name = _name, bundle = _bundle {
                let aa = Application(name: name, bundleID: bundle)
                activeApp = aa
                knownApps.insert(aa)
                if let delegate = delegate {
                    delegate.anAppBecameActive(aa)
                } else {
                    fatalError() // WIP
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
    // - If the active application is forbidden: only updates the count.
    // - Appends new strings to "copiedStrings".
    // - Calls the delegate.
    // Has to be marked @objc because it's private *and* called by NSTimer.
    // TODO: Learn to also copy other types than Strings.
    @objc private func checkForChangesInPasteboard() {
        if pasteboard.changeCount != changeCount {
            
            changeCount = pasteboard.changeCount
            
            print(pasteboard.types!)
//            if let test = pasteboard.stringForType("public.utf8-plain-text") {
//                print(test)
//            } else {
//                print("no")
//            }
//          

            // Get a string. If it is an URL or contains URLs it will be managed by the final object.
            // NSPasteboardTypeString would be ideal but is forbidden with Sandbox (damn you Sandbox).
            if let copiedString = pasteboard.stringForType("public.utf8-plain-text") {
                foundAString(copiedString)
            // Because WIP and fuck DRY for once...
            // This one looks equivalent and looks like is not forbidden.
            } else if let copiedString = pasteboard.stringForType(NSStringPboardType) {
                foundAString(copiedString)
            // Better than nothing, eh.
            } else if let copiedString = pasteboard.stringForType("public.utf16-external-plain-text") {
                foundAString(copiedString)
            }
            
            // Get a filename (or a multiple selection of filenames) with full path.
            if let plist = pasteboard.propertyListForType(NSFilenamesPboardType),
                paths = plist as? [String] {
                    for path in paths {
                        foundAString(path)
                    }
            }
            
            // Get an image or a multiple selection of images.
            if let images = pasteboard.readObjectsForClasses([NSImage.self], options: nil) as? [NSImage] {
                for image in images {
                    foundAnImage(image)
                }
            }
        }
    }
    
    private func foundAString(string: String) {
        if let source = activeApp where !forbiddenApps.contains(source) {
            let st = CopiedString(string, source: source)
            copiedStrings.append(st)
            if let delegate = delegate {
                delegate.newlyCopiedStringObtained(st)
            } else {
                fatalError() // WIP
            }
        }
    }
    
    private func foundAnImage(image: NSImage) {
        if let source = activeApp where !forbiddenApps.contains(source) {
            copiedImages.append(CopiedImage(image, source: source))
        }
    }
    
}