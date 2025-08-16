//
//  UIImageView+Extensions.swift
//  Flix
//
//  Created by NJ Development on 05/08/25.
//

import Foundation
import UIKit

public extension UIImageView {
    convenience init(icon: Icon) {
        let image = UIImage(icon: icon) ?? UIImage(systemName: "circle.slash") ?? UIImage()
        self.init(image: image)
    }
    
    func setRating(_ rating: Double) {
        let icon: Icon
        switch rating {
        case 0..<3.3:
            icon = .star
        case 3.3..<6.6:
            icon = .starHalfFilled
        default:
            icon = .starFill
        }
        self.image = UIImage(icon: icon)
    }
}

public extension UIImage {
    convenience init?(icon: Icon) {
        self.init(systemName: icon.rawValue)
    }
}

public enum Icon: String {
    case tv = "tv"
    case tvFill = "tv.fill"
    case heart = "heart"
    case heartFill = "heart.fill"
    case star = "star"
    case starHalfFilled = "star.leadinghalf.filled"
    case starFill = "star.fill"
    case exclamationMarkIcloud = "exclamationmark.icloud"
}
