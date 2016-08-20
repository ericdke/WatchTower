//
//  CopiedStringsCollection.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 19/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// A struct to replace `array`, to implement a capacity limit and restricted privileges.
// TODO: it's rather prototypal and probably not optimal, it may have to change in the future.
class CopiedStringsCollection {
    
    // The maximum number of items in the collection.
    var limit:Int
    
    // Init with a maximum number of items or let it use the default value.
    init(limit: Int = 50) {
        self.limit = limit
    }
    
    // The private array of CopiedStrings.
    fileprivate var collection = [CopiedString]()
    
    // Insert a CopiedString.
    // Removes the last item before inserting if the collection is full.
    // Only inserts if not previously inserted at this index or if collection is empty.
    func insert(_ string: CopiedString) {
        if let one = first , string != one {
            _insert(string)
        } else if collection.isEmpty {
            _insert(string)
        }
    }
    fileprivate func _insert(_ string: CopiedString) {
        if collection.count >= limit {
            collection.removeLast()
        }
        collection.insert(string, at: 0)
    }
    
    // Append a CopiedString.
    // Removes the first item before appending if the collection is full.
    // Only appends if not previously appended at this index or if collection is empty.
    func append(_ string: CopiedString) {
        if let end = last , string != end {
            _append(string)
        } else if collection.isEmpty {
            _append(string)
        }
    }
    fileprivate func _append(_ string: CopiedString) {
        if collection.count >= limit {
            collection.removeFirst()
        }
        collection.append(string)
    }
    
    // For convenience.
    func append(_ content: String, source: Application) {
        append(CopiedString(content: content, source: source))
    }
    
    // We will need those later...
    func remove(at index: Int) {
        collection.remove(at: index)
    }
    
    func removeFirst() {
        collection.removeFirst()
    }
    
    func removeLast() {
        collection.removeLast()
    }
    
    var first: CopiedString? {
        return collection.first
    }
    
    var last: CopiedString? {
        return collection.last
    }
    
    // Safe way to retrieve an item: returns an Optional.
    func get(at index: Int) -> CopiedString? {
        if collection.count > index {
            return collection[index]
        }
        return nil
    }
    
    // All items in the order they were added
    // (they could have been appended or inserted - we will allow moving items in lists).
    var all: [CopiedString] {
        return collection
    }
    
    // All items sorted by creation date.
    var sorted: [CopiedString] {
        return collection.sorted { $0.date > $1.date }
    }
    
    func sort() {
        collection.sort { $0.date > $1.date }
    }
    
}
