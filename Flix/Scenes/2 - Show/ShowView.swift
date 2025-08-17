//
//  ShowView.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import UIKit

enum Section {
    case main
}

final class ShowView: UIView {
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let padding: CGFloat = 10
        let widthScreen = (UIScreen.main.bounds.width) / 3.5

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding + 20, right: padding)
        layout.itemSize = CGSize(width: widthScreen, height: widthScreen * 1.5)
        layout.minimumLineSpacing = 15

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(ShowCell.self, forCellWithReuseIdentifier: ShowCell.identifier)
        return cv
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .systemOrange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var dataSource: UICollectionViewDiffableDataSource<Section, TVShow>!

    // MARK: - Initialization
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .systemBackground
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubviews(collectionView, activityIndicator/*, spinner, loadingLabel*/)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
}
