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
    private let actorImageView: UIImageView = {
        let imageView = UIImageView(icon: .personFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
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

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubviews(actorImageView, stackView)

        NSLayoutConstraint.activate([
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actorImageView.widthAnchor.constraint(equalToConstant: 50),
            actorImageView.heightAnchor.constraint(equalToConstant: 50),

            stackView.leadingAnchor.constraint(equalTo: actorImageView.trailingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    // MARK: - Methods
    func configure(with cast: Cast) {
        nameLabel.text = cast.person.name
        
        if let character = cast.character?.name {
            characterLabel.text = "as \(character)"
        }
        
        if let image = cast.person.image?.original, let url = URL(string: image) {
            actorImageView.sd_setImage(with: url)
        } else {
            actorImageView.image = UIImage(icon: .personFill)
        }
    }
}
