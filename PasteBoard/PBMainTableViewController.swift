//
//  PBMainTableView.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 23/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

class PBMainTableViewController: NSObject, NSTableViewDataSource, NSTableViewDelegate, PBTableViewDelegate {

    let watcher = PasteboardWatcher.sharedInstance

    @IBOutlet weak var mainTable: NSTableView!
    
    override init() {
        super.init()
        watcher.pbtvDelegate = self
    }
    
    func anObjectWasCopied() {
        mainTable.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return watcher.strings.all.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.make(withIdentifier: "PBMainColumn", owner: self)
                as? NSTableCellView else {
            return nil
        }
        cellView.textField?.stringValue = watcher.strings.get(at: row)!.content
        return cellView
    }
    
    @IBAction func onAction(_ sender: AnyObject) {
        // We shouldn't do much here, maybe even nothing. Indeed a single click is always called before a double-click, so it could be confusing to have one-click action.
        // Maybe just change the color or something like that.
        
//        if let table = sender as? NSTableView {
//            print("single click on row \(table.selectedRowIndexes.firstIndex)")
//        }
    }
    
    @IBAction func onDoubleAction(_ sender: AnyObject) {
        if let table = sender as? NSTableView {
            if let row = table.selectedRowIndexes.first {
                print("double click on row \(row)")
                if let copiedString = watcher.strings.get(at: row) {
                    let result = watcher.set(string: copiedString.content)
                    if result.NSSPT || result.UTF8 || result.UTF16 {
                        print("copied: \(copiedString.content.shortVersion(limit: 50))")
                    } else {
                        fatalError("while writing to the pasteboard")
                    }
                }
            }
        }
    }
}
