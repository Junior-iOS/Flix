//
//  ShowCell.swift
//  Flix
//
//  Created by NJ Development on 01/08/25.
//

import SDWebImage
import UIKit

final class ShowCell: UICollectionViewCell {
    // MARK: - Properties
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()

    // MARK: - Initialization
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    func configure(show: TVShow) {
        guard let url = URL(string: show.mediumPosterImage) else { return }
        coverImageView.sd_setImage(with: url)
    }

    // MARK: - Private Methods
    private func setupView() {
        setHierarchy()
        setConstraints()
        setupShadow()
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 6
        layer.masksToBounds = false

        backgroundColor = .clear

        // Adiciona um leve padding para a sombra não ser cortada
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: -2, dy: -2), cornerRadius: 10).cgPath
    }

    private func setHierarchy() {
        addSubview(coverImageView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateShadowPath() {
        layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: -2, dy: -2), cornerRadius: 10).cgPath
    }
}
