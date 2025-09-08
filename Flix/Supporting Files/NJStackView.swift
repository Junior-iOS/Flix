//
//  NJStackView.swift
//  NJKit
//
//  Created by NJ Development on 18/08/25.
//

import UIKit

public final class NJStackView: UIStackView {

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Inicializador principal
    public init(
        arrangedSubviews: UIView...,
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        super.init(frame: .zero)

        arrangedSubviews.forEach { addArrangedSubview($0) }

        self.spacing = spacing
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment

        configure()
    }

    // MARK: - Private Methods

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
