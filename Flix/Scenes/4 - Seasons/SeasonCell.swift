//
//  SeasonCell.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import UIKit

final class SeasonCell: UICollectionViewCell {
    private let seasonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let badgeLabel = NJBadgeLabel()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemOrange
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    private func setup() {
        contentView.addSubviews(
            seasonImageView,
            yearLabel,
            badgeLabel,
            activityIndicator
        )

        NSLayoutConstraint.activate([
            seasonImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seasonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seasonImageView.heightAnchor.constraint(equalToConstant: 200),

            activityIndicator.centerXAnchor.constraint(equalTo: seasonImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: seasonImageView.centerYAnchor),

            badgeLabel.topAnchor.constraint(equalTo: seasonImageView.topAnchor, constant: -8),
            badgeLabel.trailingAnchor.constraint(equalTo: seasonImageView.trailingAnchor, constant: 8),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),
            badgeLabel.widthAnchor.constraint(equalToConstant: 24),

            yearLabel.topAnchor.constraint(equalTo: seasonImageView.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with item: ShowSeasonsView.SeasonItem) {
        seasonImageView.sd_setImage(with: URL(string: item.imageURL ?? "")) { [weak self] image, _, _, _ in
            guard let self else { return }
            if image == nil { seasonImageView.image = UIImage(icon: .exclamationMarkIcloud) }
            activityIndicator.stopAnimating()
        }
        badgeLabel.text = "T\(item.seasonNumber)"
        yearLabel.text = dateFormat(text: "Aired", item.year ?? "N/A")
    }
}
