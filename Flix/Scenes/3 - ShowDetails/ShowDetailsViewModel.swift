//
//  ShowDetailsViewModel.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import UIKit

protocol ShowDetailsViewModelProtocol {
    func toggleFavorite()
    var title: String { get }
    var show: TVShow { get }
}

final class ShowDetailsViewModel: ShowDetailsViewModelProtocol {
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    
    // MARK: - Properties
    var show: TVShow

    // MARK: - Properties
    var title: String {
        show.name
    }

    // MARK: - Init
    init(
        show: TVShow,
        service: ServiceProtocol = Service(),
        networkMonitor: NetworkMonitor = NetworkMonitor.shared
    ) {
        self.show = show
        self.service = service
        self.networkMonitor = networkMonitor
        checkFavoriteStatus()
    }

//    // MARK: - Methods
    func toggleFavorite() {
//        let currentStatus = isFavoriteRelay.value
//        isFavoriteRelay.accept(!currentStatus)
//        
//        if !currentStatus {
//            // Adicionar aos favoritos
//            saveToFavorites()
//        } else {
//            // Remover dos favoritos
//            removeFromFavorites()
//        }
    }

//    // MARK: - Private Methods

    private func checkFavoriteStatus() {
//        let favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
    }

    private func saveToFavorites() {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if !favorites.contains(show.id) {
            favorites.append(show.id)
            UserDefaults.standard.set(favorites, forKey: "favorites")
            print("✅ Show adicionado aos favoritos")
        }
    }

    private func removeFromFavorites() {
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        favorites.removeAll { $0 == show.id }
        UserDefaults.standard.set(favorites, forKey: "favorites")
        print("❌ Show removido dos favoritos")
    }
}
