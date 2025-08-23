//
//  CastDetailsView.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit
import NJKit

protocol CastDetailsViewDelegate: AnyObject {
    func didTapTvmaze()
}

final class CastDetailsView: UIView {
    
    // MARK: - Private Properties
    private struct Constants {
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let ageSize: CGFloat = 100
        static let coverWidth: CGFloat = 300
        static let coverHeight: CGFloat = 350
        static let ratingSize = CGSize(width: 10, height: 10)
    }
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(icon: .exclamationMarkIcloud)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var nameLabel = NJLabel(
        textAlignment: .center,
        textColor: .label,
        fontSize: 24,
        fontWeight: .bold
    )
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(icon: .starFill)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = Constants.ratingSize
        imageView.isHidden = true
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var nameStack = NJStackView(
        arrangedSubviews: nameLabel, starImageView,
        spacing: 5,
        axis: .vertical,
        distribution: .fillProportionally,
        alignment: .center
    )

    private lazy var birthdayLabel = NJLabel(
        textColor: .label,
        fontSize: 18
    )
    
    private lazy var deathdayLabel = NJLabel(
        textAlignment: .right,
        textColor: .secondaryLabel,
        fontSize: 18
    )
    
    private lazy var lifeCycleStack = NJStackView(
        arrangedSubviews: birthdayLabel, deathdayLabel,
        spacing: 1,
        distribution: .fill,
        alignment: .leading
    )
    
    private lazy var ageLabel = NJLabel(
        textAlignment: .right,
        textColor: .label,
        fontSize: 18
    )
    
    private lazy var lifeStack = NJStackView(
        arrangedSubviews: lifeCycleStack, ageLabel,
        spacing: 5,
        axis: .horizontal,
        distribution: .fillProportionally,
        alignment: .center
    )
    
    private lazy var tvMazeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Visit TVMaze", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.backgroundColor = .systemGray6
        button.addTarget(self, action: #selector(handleVisitTvmaze), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CastDetailsViewDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        
        addSubviews(
            coverImageView,
            nameStack,
            lifeStack,
            tvMazeButton
        )
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.large),
            coverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: Constants.coverWidth),
            coverImageView.heightAnchor.constraint(equalToConstant: Constants.coverHeight),

            nameStack.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: Constants.large),
            nameStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.large),
            nameStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.large),

            lifeStack.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: Constants.medium),
            lifeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.large),
            lifeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.large),
            
            ageLabel.widthAnchor.constraint(equalToConstant: Constants.ageSize),
            
            tvMazeButton.topAnchor.constraint(equalTo: lifeStack.bottomAnchor, constant: Constants.large),
            tvMazeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.large),
            tvMazeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.large),
            tvMazeButton.heightAnchor.constraint(equalToConstant: Constants.large)
        ])
    }
    
    @objc private func handleVisitTvmaze() {
        delegate?.didTapTvmaze()
    }
    
    // MARK: - Configuration
    func configure(with vm: CastDetailsViewModelProtocol) {
        nameLabel.text = vm.nameText
        birthdayLabel.text = vm.birthdayText
        deathdayLabel.text = vm.deathdayText
        ageLabel.text = vm.ageText
        starImageView.isHidden = !vm.showStar
        
        if let url = vm.coverImageURL {
            coverImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                guard let self, let image else { return }
                if vm.shouldApplyGrayScale {
                    let ciImage = CIImage(image: image)
                    let filter = CIFilter(name: "CIPhotoEffectMono")
                    filter?.setValue(ciImage, forKey: kCIInputImageKey)
                    
                    if let output = filter?.outputImage {
                        let context = CIContext()
                        if let cgImage = context.createCGImage(output, from: output.extent) {
                            self.coverImageView.image = UIImage(cgImage: cgImage)
                        }
                    }
                } else {
                    self.coverImageView.image = image
                }
            }
        }
    }
}
