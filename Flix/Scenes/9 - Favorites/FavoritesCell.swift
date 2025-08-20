//
//  FavoritesViewController.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import UIKit
import NJKit
import SDWebImage

final class FavoritesCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private struct Constants {
        static let padding: CGFloat = 12
        static let nameLabelHeight: CGFloat = 30
        static let imageWidthAnchor: CGFloat = 80
        static let imageHeightAnchor: CGFloat = 130
        static let heightAnchor: CGFloat = 150
    }
    private lazy var nameLabel = NJLabel(textColor: .label, fontSize: 16, fontWeight: .bold)
    private lazy var summaryLabel = NJLabel(textColor: .secondaryLabel, fontSize: 14)
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(icon: .exclamationMarkIcloud)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stackView = NJStackView(
        arrangedSubviews: nameLabel, summaryLabel,
        axis: .vertical,
        distribution: .fill
    )
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubviews(coverImageView, stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.heightAnchor),
            
            coverImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            coverImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidthAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeightAnchor),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding),
            
            nameLabel.heightAnchor.constraint(equalToConstant: Constants.nameLabelHeight)
        ])
    }
    
    // MARK: - Public Methods
    func configure(show: TVShow) {
        guard let url = URL(string: show.originalPosterImage) else { return }
        coverImageView.sd_setImage(with: url)
        nameLabel.text = show.name
        summaryLabel.text = show.summary.removingHTMLOccurances
    }
}
