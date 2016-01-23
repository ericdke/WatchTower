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
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return watcher.copiedStrings.allItems.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cellView = tableView.makeViewWithIdentifier("PBMainColumn", owner: self) as? NSTableCellView else { return nil }
        cellView.textField?.stringValue = watcher.copiedStrings.getAtIndex(row)!.content
        return cellView
    }
    
}
