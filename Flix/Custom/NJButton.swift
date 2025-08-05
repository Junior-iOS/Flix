//
//  NJButton.swift
//  Flix
//
//  Created by NJ Development on 03/08/25.
//

import Foundation
import UIKit

class NJButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    init(backgroundColor: UIColor, title: String, target: Any, action: Selector) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
