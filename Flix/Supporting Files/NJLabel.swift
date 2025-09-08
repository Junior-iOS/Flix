//
//  NJLabel.swift
//  Flix
//
//  Created by NJ Development on 03/08/25.
//

import Foundation
import UIKit

public class NJLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    public init(
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor?,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight = .regular,
        numberOfLines: Int = 0
    ) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.numberOfLines = numberOfLines
        configure()
    }

    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
