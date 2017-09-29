//
//  PasteBoardWatcher.swift
//  PasteBoard
//
//  Created by Eric D. on 18/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

class PasteboardWatcher {
    
    // MARK: PROPERTIES
    
    // This class is a Singleton.
    static let sharedInstance = PasteboardWatcher()
    
    fileprivate let pasteboard = NSPasteboard.general
    
    var delegate: PasteboardWatcherDelegate?
    
    var pbtvDelegate: PBTableViewDelegate?
    
    // Keep track of the changes in the pasteboard.
    fileprivate var changeCount: Int
    
    // Used to regularly poll the pasteboard for changes.
    fileprivate var timer: Timer?
    
    // A set of applications we've already copied from.
    var knownApps = Set<Application>()
    
    // The current active application.
    var activeApp:Application?
    
    // Applications we won't copy from.
    var forbiddenApps = [Application(name: "1Password",
                                     bundleID: "com.agilebits.onepassword-osx"),
                         Application(name: "1Pasword mini",
                                     bundleID: "2BUA8C4S2C.com.agilebits.onepassword-osx-helper"),
                         Application(name: "Keychain Access",
                                     bundleID: "com.apple.keychainaccess"),
                         Application(name: "WatchTower",
                                     bundleID: "com.tests.PasteBoard")] // This is us! Temporary.
    
    // The collection of copied strings.
    let strings = CopiedStringsCollection()
    
    // The collection of copied images.
    let images = CopiedImagesCollection()
    
    // MARK: INIT
    
    private init() { // private because singleton
        // On launch, we mirror the pasteboard context.
        self.changeCount = pasteboard.changeCount
        
        // Registers if any application becomes active (or comes frontmost) and calls a method if it's the case.
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                            selector: #selector(PasteboardWatcher.activeApp(_:)),
                                                            name: NSWorkspace.didActivateApplicationNotification,
                                                            object: nil)
    }
    
    // MARK: WATCHER
    
    // Called by NSWorkspace when any application becomes active or comes frontmost.
    @objc fileprivate func activeApp(_ sender: Notification) {
        if let info = (sender as NSNotification).userInfo,
            let ak = info[NSWorkspace.applicationUserInfoKey] {
            let content = ak as AnyObject
            if let _name = content.localizedName,
                    let _bundle = content.bundleIdentifier,
                    let name = _name, let bundle = _bundle {
                let aa = Application(name: name,
                                     bundleID: bundle)
                activeApp = aa
                knownApps.insert(aa)
                if let delegate = delegate {
                    delegate.anAppBecameActive(aa)
                } else {
                    fatalError() // WIP
                }
                
            }
        }
    }
    
    // Regularly polls the general pasteboard to see if there's been changes.
    // Not very pretty, but even Apple does it like this, so let's go.
    func startPolling() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.2,
                                          target: self,
                                          selector: #selector(PasteboardWatcher.checkForChangesInPasteboard),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    // MARK: GET
    
    // Called by the timer.
    // If there's been a change in the general pasteboard:
    // - If the active application is forbidden: only updates the count.
    // - Appends new items to the collections.
    // - Calls the delegate.
    @objc fileprivate func checkForChangesInPasteboard() {
        if pasteboard.changeCount != changeCount {
            
            changeCount = pasteboard.changeCount

            // Get a string. If it is an URL or contains URLs it will be managed by the final object.
            // NSPasteboardTypeString would be ideal but is forbidden with Sandbox (damn you Sandbox).
            if let copiedString = pasteboard.string(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) {
                found(string: copiedString)
            // Because WIP and fuck DRY for once...
            } else if let copiedString = pasteboard.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) {
                found(string: copiedString)
            // Better than nothing, eh.
            } else if let copiedString = pasteboard.string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf16-external-plain-text")) {
                found(string: copiedString)
            }
            
            // Get a filename (or a multiple selection of filenames) with full path.
            if let paths = pasteboard.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as? [String] {
                paths.forEach { found(string: $0) }
            }
            
            // Get an image or a multiple selection of images.
            if let images = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) as? [NSImage] {
                images.forEach { found(image: $0) }
            }
        }
    }
    
    fileprivate func found(string: String) {
        if let source = activeApp , !forbiddenApps.contains(source) {
            let st = CopiedString(content: string, source: source)
            strings.insert(st)
            if let delegate = delegate {
                delegate.newlyCopiedStringObtained(st)
            } else {
                fatalError() // WIP
            }
            if let delegate = pbtvDelegate {
                delegate.anObjectWasCopied()
            } else {
                fatalError() // WIP
            }
        }
    }
    
    fileprivate func found(image: NSImage) {
        if let source = activeApp , !forbiddenApps.contains(source) {
            images.insert(CopiedImage(content: image, source: source))
            if let delegate = pbtvDelegate {
                delegate.anObjectWasCopied()
            } else {
                fatalError() // WIP
            }
        }
    }
    
    // MARK: SET
    
    func set(string content: String) -> (NSSPT: Bool, UTF8: Bool, UTF16: Bool) {
        // Returns the new pasteboard's changeCount: ignored, we already have this managed.
        let _ = pasteboard.declareTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType"), NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"), NSPasteboard.PasteboardType(rawValue: "public.utf16-external-plain-text")], owner: nil)
        // Write the string to the general pasteboard in compatible formats.
        let pastedNSSPT = pasteboard.setString(content, forType: NSPasteboard.PasteboardType("NSFilenamesPboardType"))
        let pastedUTF8 = pasteboard.setString(content, forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))
        let pastedUTF16 = pasteboard.setString(content, forType: NSPasteboard.PasteboardType(rawValue: "public.utf16-external-plain-text"))
        return (pastedNSSPT, pastedUTF8, pastedUTF16)
    }
    
}
