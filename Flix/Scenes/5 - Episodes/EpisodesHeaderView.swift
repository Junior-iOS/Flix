//
//  HeroHeaderView.swift
//  Flix
//
//  Created by NJ Development on 16/08/25.
//

import UIKit

final class EpisodesHeaderView: UIView {
    typealias SeasonItem = ShowSeasonsView.SeasonItem

    private let episodeImage: UIImageView = {
        let imageView = UIImageView(icon: .exclamationMarkIcloud)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        return imageView
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        layer.locations = [0.0, 1.0]

        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(episodeImage)
        episodeImage.layer.addSublayer(gradientLayer)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        episodeImage.frame = bounds
        gradientLayer.frame = episodeImage.bounds
    }

    func configure(with season: SeasonItem) {
        guard let image = season.imageURL, let url = URL(string: image) else { return }
        DispatchQueue.main.async {
            self.episodeImage.sd_setImage(with: url)
        }
    }
}
