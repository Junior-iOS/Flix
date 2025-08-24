//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import NJKit
import SDWebImage
import UIKit

final class EpisodeDetailsView: UIView {
    // MARK: - Private Properties
    private struct Constants {
        static let padding: CGFloat = 16
        static let episodeTitleHeight: CGFloat = 44
        static let episodeImageHeight: CGFloat = UIScreen.main.bounds.height / 3
        static let ratingSize = CGSize(width: 10, height: 10)
    }

    private let episodeImage: UIImageView = {
        let imageView = UIImageView(icon: .exclamationMarkIcloud)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var episodeTitleLabel: NJLabel = {
        NJLabel(
            textAlignment: .center,
            textColor: .label,
            fontSize: 24,
            fontWeight: .bold,
            numberOfLines: 0
        )
    }()

    private lazy var airDateLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )

    private lazy var airTimeLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )

    private lazy var runTimeLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )
    
    lazy var durationStack = NJStackView(
        arrangedSubviews: runTimeLabel, airDateLabel, airTimeLabel,
        spacing: 1,
        distribution: .fillEqually,
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
    
    private lazy var summaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
        return textView
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
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubviews(
            episodeImage,
            episodeTitleLabel,
            showInfoStack,
            summaryTextView,
            activityIndicator
        )
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            episodeImage.topAnchor.constraint(equalTo: topAnchor, ),
            episodeImage.leadingAnchor.constraint(equalTo: leadingAnchor, ),
            episodeImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            episodeImage.heightAnchor.constraint(equalToConstant: Constants.episodeImageHeight),

            activityIndicator.centerXAnchor.constraint(equalTo: episodeImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: episodeImage.centerYAnchor),

            episodeTitleLabel.topAnchor.constraint(equalTo: episodeImage.bottomAnchor, constant: Constants.padding),
            episodeTitleLabel.leadingAnchor.constraint(equalTo: episodeImage.leadingAnchor, constant: Constants.padding),
            episodeTitleLabel.trailingAnchor.constraint(equalTo: episodeImage.trailingAnchor, constant: -Constants.padding),
            episodeTitleLabel.heightAnchor.constraint(equalToConstant: Constants.episodeTitleHeight),

            showInfoStack.topAnchor.constraint(equalTo: episodeTitleLabel.bottomAnchor, constant: Constants.padding),
            showInfoStack.leadingAnchor.constraint(equalTo: episodeTitleLabel.leadingAnchor),
            showInfoStack.trailingAnchor.constraint(equalTo: episodeTitleLabel.trailingAnchor),

            summaryTextView.topAnchor.constraint(equalTo: showInfoStack.bottomAnchor, constant: Constants.padding),
            summaryTextView.leadingAnchor.constraint(equalTo: showInfoStack.leadingAnchor),
            summaryTextView.trailingAnchor.constraint(equalTo: showInfoStack.trailingAnchor),
            summaryTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Methods
    func configure(with episode: Episode) {
        episodeTitleLabel.text = episode.name
        airDateLabel.text = self.dateFormat(text: "Aired in", episode.airdate ?? "N/A")
        ratingImageView.setRating(episode.rating.average ?? 0)
        ratingLabel.text = "\(episode.rating.average ?? 0)"
        summaryTextView.text = episode.summary?.removingHTMLOccurances

        if let urlString = episode.image?.original, let url = URL(string: urlString) {
            episodeImage.sd_setImage(
                with: url,
                placeholderImage: UIImage(icon: .exclamationMarkIcloud),
                options: [.continueInBackground, .scaleDownLargeImages]
            ) { [weak self] _, _, _, _ in
                self?.activityIndicator.stopAnimating()
            }
        } else {
            episodeImage.image = UIImage(icon: .exclamationMarkIcloud)
            activityIndicator.stopAnimating()
        }

        if let airtime = episode.airtime {
            self.airTimeLabel.text = "\(airtime)h"
        }

        if let runtime = episode.runtime {
            runTimeLabel.text = "\(runtime) min"
        }
    }
}
