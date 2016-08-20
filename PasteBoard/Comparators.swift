//
//  Comparators.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 24/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

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
