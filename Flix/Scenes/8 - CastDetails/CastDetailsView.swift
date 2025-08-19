//
//  CastDetailsView.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit
import NJKit

final class CastDetailsView: UIView {
    
    // MARK: - Private Properties
    private struct Constants {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 44
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
        addSubviews(
            coverImageView,
            nameStack,
            lifeStack
        )
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            coverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 300),
            coverImageView.heightAnchor.constraint(equalToConstant: 350),

            nameStack.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 24),
            nameStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            lifeStack.topAnchor.constraint(equalTo: nameStack.bottomAnchor, constant: 16),
            lifeStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            lifeStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            lifeStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24),
            
            ageLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - Configuration
    func configure(with person: Person) {
        if let urlString = person.image?.original, let url = URL(string: urlString) {
            self.coverImageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                guard let self, let image else { return }
                
                if person.deathday != nil {
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
        
        nameLabel.text = person.name
        birthdayLabel.text = dateFormat(text: "Birthday:", person.birthday ?? "Unknown")
        
        if let deathday = person.deathday {
            deathdayLabel.text = dateFormat(text: "Deathday:", deathday)
            starImageView.isHidden = false
        }
    
        if let birthday = person.birthday, let age = calculateAge(from: birthday) {
            ageLabel.text = "Age: \(age)"
        }
    }
}
