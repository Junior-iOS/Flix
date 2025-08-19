//
//  ShowSeasonsViewModel.swift
//  Flix
//
//  Created by NJ Development on 09/08/25.
//

import Foundation
import RxSwift
import UIKit

protocol ShowSeasonsViewModelProtocol {
    var seasonsSubject: PublishSubject<[Season]> { get }
    var show: TVShow { get }
    var title: String { get }
    func fetchSeasons()
}

final class ShowSeasonsViewModel: ShowSeasonsViewModelProtocol {
    // MARK: - Properties
    let seasonsSubject = PublishSubject<[Season]>()
    var show: TVShow
    var title = "Seasons"

    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private let disposeBag = DisposeBag()

    init(
        show: TVShow,
        service: ServiceProtocol = Service(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.show = show
        self.service = service
        self.networkMonitor = networkMonitor
    }

    func fetchSeasons() {
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão com a internet")
            return
        }

        service.getSeasons(showID: show.id)
            .subscribe(onSuccess: { [weak self] seasons in
                self?.seasonsSubject.onNext(seasons)
            }, onFailure: { [weak self] _ in
                self?.handleFailure()
            })
            .disposed(by: disposeBag)
    }

    private func handleFailure() {
        // Aqui você pode lidar com erros, como exibir um alerta ou logar o erro
        print("❌ Erro ao buscar temporadas")
        seasonsSubject.onError(ServiceError.invalidData)
    }
}
