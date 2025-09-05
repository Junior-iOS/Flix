//
//  SeasonCell.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import NJKit
import UIKit

final class SeasonCell: UICollectionViewCell {
    // MARK: - Private Properties
    
    private struct Constants {
        static let imageSize: CGFloat = 200
        static let tinyPadding: CGFloat = 4
        static let smallPadding: CGFloat = 8
        static let yearLabelHeight: CGFloat = 20
        static let bagdeSize: CGFloat = 28
    }
    
    private let badgeLabel = NJBadgeLabel(cornerRadius: Constants.bagdeSize / 2)
    
    private let seasonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods
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
            seasonImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            activityIndicator.centerXAnchor.constraint(equalTo: seasonImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: seasonImageView.centerYAnchor),

            badgeLabel.topAnchor.constraint(equalTo: seasonImageView.topAnchor, constant: -Constants.smallPadding),
            badgeLabel.trailingAnchor.constraint(equalTo: seasonImageView.trailingAnchor, constant: Constants.smallPadding),
            badgeLabel.heightAnchor.constraint(equalToConstant: Constants.bagdeSize),
            badgeLabel.widthAnchor.constraint(equalToConstant: Constants.bagdeSize),

            yearLabel.topAnchor.constraint(equalTo: seasonImageView.bottomAnchor, constant: Constants.tinyPadding),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: Constants.yearLabelHeight)
        ])
    }

    // MARK: - Public Methods
    func configure(with item: ShowSeasonsView.SeasonItem) {
        seasonImageView.sd_setImage(with: URL(string: item.imageURL ?? "")) { [weak self] image, _, _, _ in
            guard let self else { return }
            if image == nil { seasonImageView.image = UIImage(icon: .exclamationMarkIcloud) }
            activityIndicator.stopAnimating()
        }
        badgeLabel.text = "T\(item.seasonNumber)"
        yearLabel.text = dateFormat(text: item.year == nil ? "" :  "Aired", item.year ?? "N/A")
    }
}
