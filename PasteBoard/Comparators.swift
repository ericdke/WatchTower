//
//  Comparators.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 24/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// MARK: NSDate

extension NSDate: Comparable { }

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

// MARK: Application

func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue < rhs.hashValue
}

func >(lhs: Application, rhs: Application) -> Bool {
    return lhs.hashValue > rhs.hashValue
}

// MARK: CopiedString

func ==(lhs: CopiedString, rhs: CopiedString) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func !=(lhs: CopiedString, rhs: CopiedString) -> Bool {
    return lhs.hashValue != rhs.hashValue
}

// MARK: CopiedImage

func ==(lhs: CopiedImage, rhs: CopiedImage) -> Bool {
    return lhs.hashValue == rhs.hashValue
}