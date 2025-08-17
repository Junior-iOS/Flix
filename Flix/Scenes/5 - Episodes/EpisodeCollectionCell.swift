//
//  EpisodeCollectionCell.swift
//  Flix
//
//  Created by NJ Development on 16/08/25.
//

import SDWebImage
import UIKit

final class EpisodeCollectionCell: UICollectionViewCell {
    private let badgeLabel = NJBadgeLabel(textColor: .black, backgroundColor: .systemGray)

    private lazy var  imageView: UIImageView = {
        let imageView = UIImageView(icon: .exclamationMarkIcloud)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemOrange
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var nameLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
            activityIndicator.stopAnimating()
    }

    private func setup() {
        roundCorners([.allCorners], radius: 8)

        contentView.addSubviews(
            imageView,
            badgeLabel,
            nameLabel,
            activityIndicator
        )

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140),

            badgeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            badgeLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),
            badgeLabel.widthAnchor.constraint(equalToConstant: 24),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    func configure(with episode: Episode) {
        badgeLabel.text = "\(episode.number)"
        nameLabel.text = episode.name

        guard let image = episode.image?.original else {
            imageView.image = UIImage(icon: .exclamationMarkIcloud)
            activityIndicator.stopAnimating()
            return
        }

        imageView.sd_setImage(with: URL(string: image)) { [weak self] _, _, _, _ in
            self?.activityIndicator.stopAnimating()
        }
    }
}
