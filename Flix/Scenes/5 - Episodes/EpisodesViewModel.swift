//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 16/08/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol EpisodesViewModelProtocol {
    var episodesRelay: BehaviorRelay<[Episode]> { get }
    var show: TVShow { get }
    var season: ShowSeasonsView.SeasonItem { get }
    var title: String { get }
    func fetchEpisodes()
}

final class EpisodesViewModel: EpisodesViewModelProtocol {
    
    // MARK: - Properties
    typealias SeasonItem = ShowSeasonsView.SeasonItem
    let episodesRelay = BehaviorRelay<[Episode]>(value: [])
    var show: TVShow
    var season: SeasonItem
    
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
                guard let self = self else { return }
                let filteredEpisodes = episodes.filter { $0.season == self.season.seasonNumber }
                self.episodesRelay.accept(filteredEpisodes)
            }, onFailure: { [weak self] _ in
                self?.handleFailure()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleFailure() {
        // Aqui você pode lidar com erros, como exibir um alerta ou logar o erro
        print("❌ Erro ao buscar episódios")
        episodesRelay.accept([])
    }
}
