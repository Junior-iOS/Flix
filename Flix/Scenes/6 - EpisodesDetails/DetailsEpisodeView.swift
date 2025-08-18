//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import UIKit
import SDWebImage
import NJKit

final class DetailsEpisodeView: UIView {
    
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
        let label = NJLabel(
            textAlignment: .center,
            textColor: .label,
            fontSize: 24,
            fontWeight: .bold,
            numberOfLines: 0
        )
        return label
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
    
    lazy var durationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [runTimeLabel, airDateLabel, airTimeLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 1
        stack.distribution = .fillEqually
        stack.axis = .vertical
        return stack
    }()

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

    lazy var ratingStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingImageView, ratingLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var showInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [durationStack, ratingStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var summaryLabel = NJLabel(
        textColor: .white,
        fontSize: 16,
        fontWeight: .semibold,
        numberOfLines: 0
    )
    
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
        super.init(frame: .zero)
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
        backgroundColor = .systemBackground
        addSubviews(
            episodeImage,
            episodeTitleLabel,
            showInfoStack,
            summaryLabel,
            activityIndicator
        )
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            episodeImage.topAnchor.constraint(equalTo: topAnchor,),
            episodeImage.leadingAnchor.constraint(equalTo: leadingAnchor,),
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
            
            summaryLabel.topAnchor.constraint(equalTo: showInfoStack.bottomAnchor, constant: Constants.padding),
            summaryLabel.leadingAnchor.constraint(equalTo: showInfoStack.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: showInfoStack.trailingAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    func configure(episode: Episode) {
        episodeTitleLabel.text = episode.name
        airDateLabel.text = self.dateFormat(text: "Aired in", episode.airdate ?? "N/A")
        ratingImageView.setRating(episode.rating.average ?? 0)
        ratingLabel.text = "\(episode.rating.average ?? 0)"
        summaryLabel.text = episode.summary?.removingHTMLOccurances
        
        if let image = episode.image?.original, let url = URL(string: image) {
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
