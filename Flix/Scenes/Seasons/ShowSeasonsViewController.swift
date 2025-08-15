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

    // MARK: - UI
    private let seasonsView = ShowSeasonsView()

    // MARK: - Properties
    private let viewModel: ShowSeasonsViewModelProtocol
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
                // Atualize a UI com as temporadas recebidas
                let items = seasons.map { self.mapToViewSeason($0) }
                self.seasonsView.apply(seasons: items)
            })
            .disposed(by: disposeBag)
    }
    
    private func mapToViewSeason(_ season: Season) -> ShowSeasonsView.Season {
            // Exemplos de nomes comuns. Troque para os seus:
            // season.id               -> Int
            // season.posterURLString  -> String?
            // season.seasonNumber     -> Int
            // season.firstAirDate     -> "yyyy-MM-dd" ou String?
            return ShowSeasonsView.Season(
                id: season.id,
                imageURLString: season.image?.original,
                seasonNumber: season.number,
                year: ""
            )
        }
}

// MARK: - ShowSeasonsViewDelegate
extension ShowSeasonsViewController: ShowSeasonsViewDelegate {
    func didPullToRefresh() {
        viewModel.fetchSeasons()
    }

    func didSelectSeason(_ seasonID: Int) {
        // Navegar para detalhes/episódios da temporada
    }
}
