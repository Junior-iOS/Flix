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
    var errorSubject: PublishSubject<Error> { get }
    var show: TVShow { get }
    var title: String { get }
    func fetchSeasons()
}

final class ShowSeasonsViewModel: ShowSeasonsViewModelProtocol {
    // MARK: - Properties
    let seasonsSubject = PublishSubject<[Season]>()
    let errorSubject = PublishSubject<any Error>()
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
            DispatchQueue.main.async { [weak self] in
                let noConnectionError = NSError(domain: "NoConnection", code: -1009, userInfo: [NSLocalizedDescriptionKey: "Sem conexão com a internet"])
                self?.errorSubject.onNext(ServiceError.networkError(noConnectionError))
            }
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
        errorSubject.onNext(ServiceError.invalidData)
    }
}
