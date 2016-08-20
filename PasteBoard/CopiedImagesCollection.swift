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
    
    func append(_ content: NSImage, source: Application) {
        append(CopiedImage(content, source: source))
    }
    
    func removeAtIndex(_ index: Int) {
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
    
    func getAtIndex(_ index: Int) -> CopiedImage? {
        if collection.count > index {
            return collection[index]
        }
        return nil
    }
    
    var allItems: [CopiedImage] {
        return collection
    }
    
    var sortedItems: [CopiedImage] {
        return collection.sorted { $0.date < $1.date }
    }
    
}
