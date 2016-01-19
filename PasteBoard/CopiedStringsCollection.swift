//
//  CopiedStringsCollection.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 19/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// A struct to replace `array`, implementing a capacity limit.
class CopiedStringsCollection {
    
    // The maximum number of items in the collection.
    var limit:Int
    
    // Init with a maximum number of items or let it use the default value.
    init(limit: Int = 20) {
        self.limit = limit
    }
    
    // The private array of CopiedStrings.
    private var collection = [CopiedString]()
    
    // Insert a CopiedString.
    // Removes the last item before inserting if the collection is full.
    func insert(string: CopiedString) {
        if collection.count >= limit {
            collection.removeLast()
        }
        collection.insert(string, atIndex: 0)
    }
    
    // Append a CopiedString.
    // Removes the first item before inserting if the collection is full.
    func append(string: CopiedString) {
        if collection.count >= limit {
            collection.removeFirst()
        }
        collection.append(string)
    }
    
    func removeAtIndex(index: Int) {
        collection.removeAtIndex(index)
    }
    
    func removeFirst() {
        collection.removeFirst()
    }
    
    func removeLast() {
        collection.removeLast()
    }
    
    func getFirst() -> CopiedString? {
        return collection.first
    }
    
    func getLast() -> CopiedString? {
        return collection.last
    }
    
    func getAtIndex(index: Int) -> CopiedString? {
        if collection.count > index {
            return collection[index]
        }
        return nil
    }
    
    func getAll() -> [CopiedString] {
        return collection
    }
    
    func sortCollection() {
        collection.sortInPlace { $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 }
    }
    
}