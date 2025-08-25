//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 16/08/25.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol EpisodesViewModelProtocol {
    var episodesRelay: BehaviorRelay<[Episode]> { get }
    var show: TVShow { get }
    var season: ShowSeasonsView.SeasonItem { get }
    var title: String { get }
    var onErrorSubject: PublishSubject<Error> { get }
    func fetchEpisodes()
}

final class EpisodesViewModel: EpisodesViewModelProtocol {
    // MARK: - Properties
    typealias SeasonItem = ShowSeasonsView.SeasonItem
    let episodesRelay = BehaviorRelay<[Episode]>(value: [])
    var show: TVShow
    var season: SeasonItem
    var onErrorSubject = PublishSubject<Error>()

    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private let disposeBag = DisposeBag()

    init(
        show: TVShow,
        season: SeasonItem,
        service: ServiceProtocol = Service(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.show = show
        self.season = season
        self.service = service
        self.networkMonitor = networkMonitor

        fetchEpisodes()
    }

    var title: String {
        "Season \(season.seasonNumber)"
    }

    func fetchEpisodes() {
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão com a internet")
            return
        }

        service.getEpisodes(showID: show.id)
            .subscribe(onSuccess: { [weak self] episodes in
                guard let self else { return }
                let filteredEpisodes = episodes.filter { $0.season == self.season.seasonNumber }
                episodesRelay.accept(filteredEpisodes)
            }, onFailure: { [weak self] _ in
                self?.handleFailure()
            })
            .disposed(by: disposeBag)
    }

    private func handleFailure() {
        episodesRelay.accept([])
        onErrorSubject.onNext(ServiceError.invalidData)
    }
}
