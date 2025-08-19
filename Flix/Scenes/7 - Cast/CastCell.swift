//
//  CastCell.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import UIKit
import NJKit

final class CastCell: UITableViewCell {
    // MARK: - Private Properties
    private struct Constants {
        static let imageSize: CGFloat = 50
        static let smallPadding: CGFloat = 12
        static let mediumPadding: CGFloat = 16
    }
    
    private let actorImageView: UIImageView = {
        let imageView = UIImageView(icon: .personFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageSize / 2
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private lazy var nameLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )
    
    private lazy var characterLabel = NJLabel(
        textColor: .secondaryLabel,
        fontSize: 14,
        fontWeight: .regular,
        numberOfLines: 0
    )
    
    private lazy var stackView = NJStackView(
        arrangedSubviews: nameLabel, characterLabel,
        spacing: 2,
        axis: .vertical
    )
    
    var didSelectCast: ((Cast) -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubviews(actorImageView, stackView)

        NSLayoutConstraint.activate([
            actorImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.mediumPadding),
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.mediumPadding),
            actorImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.mediumPadding),
            actorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actorImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            actorImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            stackView.leadingAnchor.constraint(equalTo: actorImageView.trailingAnchor, constant: Constants.smallPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.mediumPadding),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Methods
    func configure(with cast: Cast) {
        nameLabel.text = cast.person.name
        
        if let character = cast.character?.name {
            characterLabel.text = "as \(character)"
        }
        
        if let urlString = cast.person.image?.original, let url = URL(string: urlString) {
            actorImageView.sd_setImage(with: url)
        } else {
            actorImageView.image = UIImage(icon: .personFill)
        }
    }
}
