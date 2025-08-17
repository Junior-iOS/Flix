//
//  String+Extensions.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import Foundation

extension String {
    public var removingHTMLOccurances: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
