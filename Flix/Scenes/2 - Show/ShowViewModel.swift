//
//  ShowViewModel.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import UIKit

protocol ShowViewModelProtocol {
    func fetchTVShows()
    func resetData()
    func refreshData()
    func cellForItem(at indexPath: IndexPath) -> TVShow
    func searchBar(textDidChange searchText: String)
    func loadNextPage()
    func shouldRefetchData() -> Bool
    
    var title: String { get }
    var showSubject: PublishSubject<[TVShow]> { get }
    var shows: Driver<[TVShow]> { get }
    var isLoading: Driver<Bool> { get }
    var numberOfItemsInSection: Int { get }
}

final class ShowViewModel: ShowViewModelProtocol {
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private var originalShows: [TVShow] = []
    private var hasOriginalData: Bool = false
    private var currentPage: Int = 0
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let showsRelay = BehaviorRelay<[TVShow]>(value: [])
    private let disposeBag = DisposeBag()

    // MARK: - Properties
    var title = "TV Shows"
    var showSubject = PublishSubject<[TVShow]>()
    var shows: Driver<[TVShow]> { showsRelay.asDriver() }
    var numberOfItemsInSection: Int { showsRelay.value.count }
    var isLoading: Driver<Bool> { isLoadingRelay.asDriver() }

    // MARK: - Init
    init(service: ServiceProtocol = Service(), networkMonitor: NetworkMonitor = NetworkMonitor.shared) {
        self.service = service
        self.networkMonitor = networkMonitor
        fetchTVShows()
    }

    // MARK: - Methods

    /// Busca a página atual de shows
    func fetchTVShows() {
        guard networkMonitor.checkConnection() else {
            // todo
            print("❌ Sem conexão com a internet")
            isLoadingRelay.accept(false)
            return
        }

        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)

        service.getShows(page: currentPage)
            .subscribe(onSuccess: { [weak self] shows in
                guard let self else { return }

                if currentPage == 0 {
                    originalShows = shows
                    showsRelay.accept(shows)
                    hasOriginalData = true
                } else {
                    originalShows.append(contentsOf: shows)
                    showsRelay.accept(originalShows)
                }

                isLoadingRelay.accept(false)
            }, onFailure: { [weak self] error in
                print("❌ Erro ao buscar shows: \(error)")
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
    }

    func loadNextPage() {
        guard !isLoadingRelay.value else { return }
        currentPage += 1
        fetchTVShows()
    }

    func cellForItem(at indexPath: IndexPath) -> TVShow {
        showsRelay.value[indexPath.item]
    }

    func searchBar(textDidChange searchText: String) {
        if searchText.isEmpty {
            showsRelay.accept(originalShows)
        } else {
            let filteredShows = originalShows.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            showsRelay.accept(filteredShows)
        }
    }

    func resetData() {
        originalShows = []
        showsRelay.accept([])
        hasOriginalData = false
        currentPage = 0
    }

    func refreshData() {
        resetData()
        fetchTVShows()
    }

    func shouldRefetchData() -> Bool {
        !hasOriginalData
    }
}
