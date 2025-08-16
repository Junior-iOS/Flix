//
//  ShowSeasonsViewController.swift
//  Flix
//
//  Created by NJ Development on 09/08/25.
//

import Foundation
import UIKit
import RxSwift

final class ShowSeasonsViewController: UIViewController {
    
    // MARK: - Properties
    typealias SeasonItem = ShowSeasonsView.SeasonItem

    // MARK: - Properties
    private let viewModel: ShowSeasonsViewModelProtocol
    private let seasonsView = ShowSeasonsView()
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(viewModel: ShowSeasonsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = seasonsView
        seasonsView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Temporadas"
        bindViewModel()
        viewModel.fetchSeasons()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.seasonsSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] seasons in
                guard let self = self else { return }
                let items: [SeasonItem] = seasons.map { self.mapToViewSeason($0) }
                self.seasonsView.apply(items: items)
            })
            .disposed(by: disposeBag)
    }
    
    private func mapToViewSeason(_ season: Season) -> SeasonItem {
        return SeasonItem(
            id: season.id,
            imageURL: season.image?.original,
            seasonNumber: season.number,
            year: season.premiereDate
        )
    }
}

// MARK: - ShowSeasonsViewDelegate
extension ShowSeasonsViewController: ShowSeasonsViewDelegate {
    func didSelectSeason(_ season: SeasonItem) {
        let episodesViewModel = EpisodesViewModel(show: viewModel.show, season: season)
        let controller = EpisodesViewController(viewModel: episodesViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
