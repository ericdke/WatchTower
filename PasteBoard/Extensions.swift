//
//  Extensions.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 21/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

// MARK: String

extension String {
    func extractURLs() -> [NSURL] {
        var urls : [NSURL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
            detector.enumerateMatchesInString(self,
                options: [],
                range: NSMakeRange(0, self.characters.count),
                usingBlock: { (result, _, _) in
                    if let match = result, url = match.URL {
                        urls.append(url)
                    }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
}





