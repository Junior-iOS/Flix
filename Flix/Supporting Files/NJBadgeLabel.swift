//
//  NJBadgeLabel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import UIKit

public class NJBadgeLabel: NJLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBadge()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    public init(text: String = "", textColor: UIColor = .white, backgroundColor: UIColor = .systemRed, cornerRadius: CGFloat = 12) {
        super.init(textAlignment: .center, textColor: textColor, fontSize: 14, fontWeight: .bold)
        self.text = text
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        configureBadge()
    }

    private func configureBadge() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
    }
}
