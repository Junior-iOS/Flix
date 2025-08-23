//
//  ShowSeasonsView.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import Foundation
import SDWebImage
import UIKit

protocol ShowSeasonsViewDelegate: AnyObject {
    func didSelectSeason(_ season: ShowSeasonsView.SeasonItem)
}

final class ShowSeasonsView: UIView {
    // MARK: - Types
    private enum Section: Hashable {
        case main
    }

    private struct Constants {
        static let cellCornerRadius: CGFloat = 8
        static let cellSpacing: CGFloat = 10
        static let minimumLineSpacing: CGFloat = 15
        static let mediumPadding: CGFloat = 16
        static let largePadding: CGFloat = 24
        static let cellSize = CGSize(width: 150, height: 200)
        static let emptyStateText = "Nenhuma temporada disponível."
    }

    /// View item para não depender do seu `Season` ser `Hashable`
    struct SeasonItem: Hashable {
        let id: Int
        let imageURL: String?
        let seasonNumber: Int
        let year: String?

        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    }

    // MARK: - Public Properties
    weak var delegate: ShowSeasonsViewDelegate?

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let padding: CGFloat = Constants.cellSpacing
        let widthScreen = (UIScreen.main.bounds.width) / 3.5

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding + 20, right: padding)
        layout.itemSize = Constants.cellSize
        layout.minimumLineSpacing = Constants.minimumLineSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.identifier)
        return collectionView
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.text = Constants.emptyStateText
        label.isHidden = true
        return label
    }()

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, SeasonItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SeasonItem>
    private var dataSource: DataSource!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        configureDataSource()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(emptyStateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumPadding),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumPadding),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.largePadding),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.largePadding)
        ])
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SeasonCell.identifier,
                for: indexPath
            ) as? SeasonCell else { return UICollectionViewCell() }
            cell.configure(with: item)
            return cell
        }

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Public API

    func apply(items: [SeasonItem], animating: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }
}

// MARK: - UICollectionViewDelegate
extension ShowSeasonsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectSeason(item)
    }
}
