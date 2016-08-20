//
//  Extensions.swift
//  PasteBoard
//
//  Created by ERIC DEJONCKHEERE on 21/01/2016.
//  Copyright © 2016 tests. All rights reserved.
//

import Foundation

extension String {
    
    func extractURLs() -> [URL] {
        var urls : [URL] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self,
                options: [],
                range: NSMakeRange(0, self.characters.count),
                using: { (result, _, _) in
                    if let match = result, let url = match.url {
                        urls.append(url)
                    }
            })
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return urls
    }
    
    func shortVersion(limit: Int) -> String {
        if self.characters.count > limit {
            return self.characters.map { String($0) }[0...(limit - 3)].joined(separator: "") + "..."
        }
        return self
    }
}




