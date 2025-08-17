//
//  NJBadgeLabel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import UIKit

class NJBadgeLabel: NJLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBadge()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    init(text: String = "", textColor: UIColor = .white, backgroundColor: UIColor = .systemRed) {
        super.init(textAlignment: .center, textColor: textColor, fontSize: 14, fontWeight: .bold)
        self.text = text
        self.backgroundColor = backgroundColor
        configureBadge()
    }

    private func configureBadge() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}
