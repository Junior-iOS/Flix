//
//  UIView+Extensions.swift
//  Flix
//
//  Created by NJ Development on 01/08/25.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    static var identifier: String {
        String(describing: self)
    }

    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5.0
    }

    func calculateAge(from birthday: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        guard let birthDate = dateFormatter.date(from: birthday) else {
            return nil
        }

        let currentDate = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)

        return ageComponents.year
    }

    func dateFormat(text: String = "", _ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        if let birthDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return text + " " + dateFormatter.string(from: birthDate)
        }
        return text
    }

        /// Rounds the specified corners with a given radius.
        /// - Parameters:
        ///   - corners: The corners to round.
        ///   - radius: The radius for the rounded corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        // Remove previously added mask if exists
        self.layer.mask = nil
        // For layout changes, ensure the path updates
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
