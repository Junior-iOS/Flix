//
//  ShowSeasonsView.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import Foundation
import UIKit
import SDWebImage

protocol ShowSeasonsViewDelegate: AnyObject {
    func didSelectSeason(_ seasonID: Int)
}

final class ShowSeasonsView: UIView {

    // MARK: - Types
    private enum Section: Hashable {
        case main
    }

    /// View item para não depender do seu `Season` ser `Hashable`
//    struct SeasonItem: Hashable {
//        let id: Int
//        let imageURL: URL?
//
//        init(id: Int, imageURL: URL?) {
//            self.id = id
//            self.imageURL = imageURL
//        }
//
//        // Hash/Equatable por id para estabilidade do snapshot
//        func hash(into hasher: inout Hasher) { hasher.combine(id) }
//        static func == (lhs: SeasonItem, rhs: SeasonItem) -> Bool { lhs.id == rhs.id }
//    }
    
    struct SeasonItem: Hashable {
        let id: Int
        let imageURL: URL?
        let seasonNumber: Int
        let year: String?

        init(id: Int, imageURL: URL?, seasonNumber: Int, year: String?) {
            self.id = id
            self.imageURL = imageURL
            self.seasonNumber = seasonNumber
            self.year = year
        }

        func hash(into hasher: inout Hasher) { hasher.combine(id) }
        static func == (lhs: SeasonItem, rhs: SeasonItem) -> Bool { lhs.id == rhs.id }
    }

    // MARK: - Public
    weak var delegate: ShowSeasonsViewDelegate?

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let padding: CGFloat = 10
        let widthScreen = (UIScreen.main.bounds.width) / 3.5
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding + 20, right: padding)
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.identifier)
        return collectionView
    }()

    private let refresh = UIRefreshControl()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "Nenhuma temporada disponível."
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
    required init?(coder: NSCoder) { nil }

    // MARK: - Setup
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(emptyStateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.identifier, for: indexPath) as? SeasonCell
            cell?.configure(with: item)
            return cell
        }
        // estado inicial vazio
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Public API

    /// Atualiza a lista com temporadas (mapeie seu `Season` para `SeasonItem` antes ou use o helper abaixo)
    func apply(items: [SeasonItem], animating: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animating)
        setEmptyStateVisible(items.isEmpty)
    }

    /// Conveniência: recebe seu `Season` e mapeia para `SeasonItem`
    
    struct Season {
        let id: Int
        let imageURLString: String?
        let seasonNumber: Int
        let year: String?
    }

    func apply(seasons: [Season], animating: Bool = true) {
        let items = seasons.map {
            SeasonItem(
                id: $0.id,
                imageURL: $0.imageURLString.flatMap { URL(string: $0) },
                seasonNumber: $0.seasonNumber,
                year: $0.year
            )
        }
        apply(items: items, animating: animating)
    }

    /// Controle do loading do refresh (chame quando terminar a busca)
    func endRefreshing() {
        if refresh.isRefreshing { refresh.endRefreshing() }
    }

    // MARK: - Helpers
    private func setEmptyStateVisible(_ visible: Bool) {
        emptyStateLabel.isHidden = !visible
        collectionView.isHidden = visible
    }
}

// MARK: - UICollectionViewDelegate
extension ShowSeasonsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectSeason(item.id)
    }
}

// MARK: - Cell
final class SeasonCell: UICollectionViewCell {
    private let seasonImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func setup() {
        contentView.addSubviews(seasonImageView, yearLabel, badgeLabel)
        
        NSLayoutConstraint.activate([
            seasonImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seasonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seasonImageView.heightAnchor.constraint(equalToConstant: 200),
            
            badgeLabel.topAnchor.constraint(equalTo: seasonImageView.topAnchor, constant: -8),
            badgeLabel.trailingAnchor.constraint(equalTo: seasonImageView.trailingAnchor, constant: 8),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24),
            badgeLabel.widthAnchor.constraint(equalToConstant: 24),
            
            yearLabel.topAnchor.constraint(equalTo: seasonImageView.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with item: ShowSeasonsView.SeasonItem) {
        seasonImageView.sd_setImage(with: item.imageURL)
        badgeLabel.text = "T\(item.seasonNumber)"
        yearLabel.text = item.year
    }
}
