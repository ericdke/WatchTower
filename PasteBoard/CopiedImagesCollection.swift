//
//  CopiedImagesCollection.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 23/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Cocoa

class CopiedImagesCollection {
    
    var limit:Int
    
    init(limit: Int = 20) {
        self.limit = limit
    }
    
    private var collection = [CopiedImage]()
    
    func insert(image: CopiedImage) {
        if collection.count >= limit {
            collection.removeLast()
        }
        collection.insert(image, atIndex: 0)
    }
    
    func append(image: CopiedImage) {
        if collection.count >= limit {
            collection.removeFirst()
        }
        collection.append(image)
    }
    
    func append(content: NSImage, source: Application) {
        append(CopiedImage(content, source: source))
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
    
    var first: CopiedImage? {
        return collection.first
    }
    
    var last: CopiedImage? {
        return collection.last
    }
    
    func getAtIndex(index: Int) -> CopiedImage? {
        if collection.count > index {
            return collection[index]
        }
        return nil
    }
    
    var allItems: [CopiedImage] {
        return collection
    }
    
    var sortedItems: [CopiedImage] {
        return collection.sort { $0.date < $1.date }
    }
    
}