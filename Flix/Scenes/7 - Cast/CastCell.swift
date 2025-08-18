//
//  CastCell.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import UIKit

final class CastCell: UITableViewCell {
    private let actorImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private let nameLabel = UILabel()
    private let characterLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        characterLabel.font = .systemFont(ofSize: 14, weight: .regular)
        characterLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [nameLabel, characterLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(actorImageView)
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            actorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actorImageView.widthAnchor.constraint(equalToConstant: 50),
            actorImageView.heightAnchor.constraint(equalToConstant: 50),

            stack.leadingAnchor.constraint(equalTo: actorImageView.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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
