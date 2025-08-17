//
//  EpisodeRowCell.swift
//  Flix
//
//  Created by NJ Development on 16/08/25.
//

import RxSwift
import SDWebImage
import UIKit

final class EpisodeRowCell: UITableViewCell {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 140, height: 180)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EpisodeCollectionCell.self, forCellWithReuseIdentifier: EpisodeCollectionCell.identifier)
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Episode>!
    private var disposeBag = DisposeBag()
    private var episodes: [Episode] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        setupDataSource()
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Episode>(collectionView: collectionView) { collectionView, indexPath, episode -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCollectionCell.identifier, for: indexPath) as? EpisodeCollectionCell else {
                print("Failed to dequeue EpisodeCollectionCell")
                return UICollectionViewCell()
            }

            cell.configure(with: episode)
            return cell
        }
    }

    func bind(to episodesObservable: Observable<[Episode]>) {
        disposeBag = DisposeBag() // reinicia sempre que a célula for reutilizada
        episodesObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] episodes in
                self?.episodes = episodes
                self?.applyEpisodes(episodes)
            }
            .disposed(by: disposeBag)
    }

    private func applyEpisodes(_ episodes: [Episode]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Episode>()
        snapshot.appendSections([0])
        snapshot.appendItems(episodes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
