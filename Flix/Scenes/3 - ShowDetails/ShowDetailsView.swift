//
//  ShowDetailsView.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import NJKit
import SDWebImage
import UIKit

protocol ShowDetailsViewDelegate: AnyObject {
    func didTapSeasonsButton()
    func didTapCastButton()
}

final class ShowDetailsView: UIView {
    // MARK: - Properties
    weak var delegate: ShowDetailsViewDelegate?

    // MARK: - Private Properties
    private struct Constants {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 44
        static let coverHeight: CGFloat = 350
        static let ratingSize = CGSize(width: 10, height: 10)
    }

    // MARK: - UI Components
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemOrange
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    lazy var titleLabel: NJLabel = {
        NJLabel(
            textAlignment: .center,
            textColor: .label,
            fontSize: 24,
            fontWeight: .bold
        )
    }()

    lazy var genresLabel: NJLabel = {
        NJLabel(
            textColor: .secondaryLabel,
            fontSize: 16
        )
    }()

    lazy var premieredLabel: NJLabel = {
        NJLabel(
            textColor: .systemBlue,
            fontSize: 14
        )
    }()

    lazy var statusLabel: NJLabel = {
        NJLabel(
            textAlignment: .left,
            textColor: .systemBlue,
            fontSize: 14
        )
    }()
    
    lazy var durationStack = NJStackView(
        arrangedSubviews: premieredLabel, statusLabel,
        spacing: 1,
        distribution: .fillEqually
    )

    lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = Constants.ratingSize
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()

    lazy var ratingLabel: NJLabel = {
        let label = NJLabel(
            textAlignment: .right,
            textColor: .secondaryLabel,
            fontSize: 14
        )
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    lazy var ratingStack = NJStackView(
        arrangedSubviews: ratingImageView, ratingLabel,
        spacing: 5,
        axis: .horizontal
    )
    
    lazy var showInfoStack = NJStackView(
        arrangedSubviews: durationStack, ratingStack,
        axis: .horizontal
    )

    lazy var summaryLabel: NJLabel = {
        NJLabel(
            textAlignment: .justified,
            textColor: .label,
            fontSize: 16
        )
    }()

    lazy var seasonsButton: NJButton = {
        NJButton(
            backgroundColor: .systemBlue,
            title: "Seasons",
            target: self,
            action: #selector(episodesButtonTapped)
        )
    }()

    lazy var castButton: NJButton = {
        NJButton(
            backgroundColor: .systemGreen,
            title: "Cast",
            target: self,
            action: #selector(castButtonTapped)
        )
    }()
    
    lazy var buttonsStack = NJStackView(
        arrangedSubviews: seasonsButton, castButton,
        spacing: 12,
        distribution: .fillEqually
    )

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods

    private func setupHierarchy() {
        addSubviews(scrollView, buttonsStack, activityIndicator)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
            coverImageView,
            titleLabel,
            genresLabel,
            showInfoStack,
            summaryLabel
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -Constants.medium),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.medium),
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 300),
            coverImageView.heightAnchor.constraint(equalToConstant: Constants.coverHeight),

            activityIndicator.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: coverImageView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.medium),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.medium),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.medium),

            genresLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.small),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.medium),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.medium),

            showInfoStack.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: Constants.small),
            showInfoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.medium),
            showInfoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.medium),

            summaryLabel.topAnchor.constraint(equalTo: showInfoStack.bottomAnchor, constant: Constants.medium),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.medium),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.medium),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.medium),
            
            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.medium),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.medium),
            buttonsStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.medium),

            seasonsButton.heightAnchor.constraint(equalToConstant: Constants.large),
            castButton.heightAnchor.constraint(equalToConstant: Constants.large),
        ])
    }

    // MARK: - Public Methods

    func configureData(with show: TVShow) {
        titleLabel.text = show.name
        genresLabel.text = show.genres.joined(separator: " • ")
        premieredLabel.text = dateFormat(text: "Premiered:", show.premiered ?? "N/A")
        statusLabel.text = dateFormat(text: "\(show.status)", show.ended ?? "N/A")
        statusLabel.textColor = show.status == "Ended" ? .tertiaryLabel : .systemGreen
        ratingImageView.setRating(show.rating.average ?? 0)
        ratingLabel.text = "\(show.rating.average ?? 0)"
        summaryLabel.text = show.summary.removingHTMLOccurances

        if let url = URL(string: show.originalPosterImage) {
            coverImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(icon: .exclamationMarkIcloud),
                options: [.continueInBackground, .scaleDownLargeImages]
            ) { [weak self] _, _, _, _ in
                self?.activityIndicator.stopAnimating()
            }
        } else {
            coverImageView.image = UIImage(icon: .exclamationMarkIcloud)
            activityIndicator.stopAnimating()
        }
    }

    // MARK: - Public Methods

    @objc private func episodesButtonTapped() {
        delegate?.didTapSeasonsButton()
    }

    @objc private func castButtonTapped() {
        delegate?.didTapCastButton()
    }
}
