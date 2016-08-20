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
    
    fileprivate var collection = [CopiedImage]()
    
    func insert(_ image: CopiedImage) {
        if collection.count >= limit {
            collection.removeLast()
        }
        collection.insert(image, at: 0)
    }
    
    func append(_ image: CopiedImage) {
        if collection.count >= limit {
            collection.removeFirst()
        }
        collection.append(image)
    }
    
    // convenience
    func append(content: NSImage, source: Application) {
        append(CopiedImage(content: content, source: source))
    }
    
    func remove(at index: Int) {
        collection.remove(at: index)
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
    
    func get(at index: Int) -> CopiedImage? {
        if collection.count > index {
            return collection[index]
        }
        return nil
    }
    
    var all: [CopiedImage] {
        return collection
    }
    
    var sorted: [CopiedImage] {
        return collection.sorted { $0.date < $1.date }
    }
    
}
