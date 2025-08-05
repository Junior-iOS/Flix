//
//  ShowViewModel.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol ShowViewModelProtocol {
    func fetchTVShows() -> Single<[TVShow]>
    func resetData()
    func refreshData() -> Single<[TVShow]>
    func cellForItem(at indexPath: IndexPath) -> TVShow
    func searchBar(textDidChange searchText: String)
    func shouldRefetchData() -> Bool
    var isLoading: Driver<Bool> { get }
    var numberOfItemsInSection: Int { get }
}

final class ShowViewModel: ShowViewModelProtocol {
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private var showsFiltered: [TVShow] = []
    private var originalShows: [TVShow] = []
    private var hasOriginalData: Bool = false
    private var currentPage: Int = 0
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let showsRelay = BehaviorRelay<[TVShow]>(value: [])
    
    // MARK: - Properties
    var shows: Driver<[TVShow]> {
        showsRelay.asDriver()
    }

    var numberOfItemsInSection: Int {
        showsRelay.value.count
    }
    
    var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver()
    }
    
    // MARK: - Init
    
    init(service: ServiceProtocol = Service(), networkMonitor: NetworkMonitor = NetworkMonitor.shared) {
        self.service = service
        self.networkMonitor = networkMonitor
    }
    
    // MARK: - Methods
    
    func fetchTVShows() -> Single<[TVShow]> {
        // Verifica conectividade antes de fazer a requisição
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão com a internet")
            let error = NetworkError.noConnection
//            coordinator?.showError(error)
            return Single.error(error)
        }
        
        print("🌐 Conectividade verificada: \(networkMonitor.getConnectionType())")
        
        return service.getShows(page: currentPage)
            .do(onSuccess: { [weak self] shows in
                if self?.currentPage == 1 {
                    // Primeira página - substitui os dados
                    self?.originalShows = shows
                    self?.showsRelay.accept(shows)
                } else {
                    // Páginas subsequentes - adiciona aos dados existentes
                    self?.originalShows.append(contentsOf: shows)
                    self?.showsRelay.accept(self?.originalShows ?? [])
                }
                
                self?.hasOriginalData = true
                self?.isLoadingRelay.accept(false)
            }, onError: { [weak self] error in
                print("❌ Fetch Error: \(error)")
                self?.isLoadingRelay.accept(false)
//                self?.coordinator?.showError(error)
            }, onSubscribe: { [weak self] in
                self?.isLoadingRelay.accept(true)
            })
    }
    
    func cellForItem(at indexPath: IndexPath) -> TVShow {
        return showsRelay.value[indexPath.item]
    }
    
    func searchBar(textDidChange searchText: String) {
        if searchText.isEmpty {
            print("📋 Showing all original shows")
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
        print("🔄 Dados resetados")
    }
    
    func refreshData() -> Single<[TVShow]> {
        print("🔄 Refresh solicitado - resetando dados e refazendo fetch")
        resetData()
        return fetchTVShows()
    }
    
    func shouldRefetchData() -> Bool {
        return !hasOriginalData
    }
}
