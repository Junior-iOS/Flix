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
    func fetchTVShows()
    func resetData()
    func refreshData()
    func cellForItem(at indexPath: IndexPath) -> TVShow
    func searchBar(textDidChange searchText: String)
    func shouldRefetchData() -> Bool
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
    
    var showSubject = PublishSubject<[TVShow]>()
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
        fetchTVShows()
    }
    
    // MARK: - Methods
    
    func fetchTVShows() {
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão com a internet")
            isLoadingRelay.accept(false)
            return
        }
        print("🌐 Conectividade verificada: \(networkMonitor.getConnectionType())")
        
        return service.getShows(page: currentPage)
            .subscribe(onSuccess: { [weak self] shows in
                guard let self = self else { return }
                print("📺 Shows recebidos: \(shows.count)")
                if self.currentPage == 0 {
                    showSubject.onNext(shows)
                    self.originalShows = shows
                    self.showsRelay.accept(shows)
                } else {
                    self.originalShows.append(contentsOf: shows)
                    self.showsRelay.accept(self.originalShows)
                }
            }, onFailure: { [weak self] error in
                print("❌ Erro ao buscar shows: \(error)")
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)

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
    
    func refreshData()  {
        resetData()
        fetchTVShows()
    }
    
    func shouldRefetchData() -> Bool {
        return !hasOriginalData
    }
}
