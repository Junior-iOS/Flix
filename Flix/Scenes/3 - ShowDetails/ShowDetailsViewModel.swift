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
    var isFavorite: Driver<Bool> { get }
    var key: String { get }
}

final class ShowDetailsViewModel: ShowDetailsViewModelProtocol {
    // MARK: - Private Properties
    private let service: ServiceProtocol
    private let networkMonitor: NetworkMonitor
    private let isFavoriteRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Properties
    var show: TVShow
    var isFavorite: Driver<Bool> {
        isFavoriteRelay.asDriver()
    }

    var title: String {
        show.name
    }
    
    var key: String {
        "favorites"
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
        self.checkFavoriteStatus()
    }

    // MARK: - Methods
    func toggleFavorite() {
        let currentStatus = isFavoriteRelay.value
        isFavoriteRelay.accept(!currentStatus)
        
        if !currentStatus {
            saveToFavorites()
        } else {
            removeFromFavorites()
        }
    }

    // MARK: - Private Methods
    private func checkFavoriteStatus() {
        if let data = UserDefaults.standard.data(forKey: key),
           let favorites = try? JSONDecoder().decode([Int].self, from: data) {
            isFavoriteRelay.accept(favorites.contains(show.id))
        } else {
            isFavoriteRelay.accept(false)
        }
    }

    private func saveToFavorites() {
        var favorites: [Int] = []
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            favorites = decoded
        }
        if !favorites.contains(show.id) {
            favorites.append(show.id)
            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: key)
                print("✅ Show adicionado aos favoritos")
            }
        }
    }

    private func removeFromFavorites() {
        var favorites: [Int] = []
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            favorites = decoded
        }
        favorites.removeAll { $0 == show.id }
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
            print("❌ Show removido dos favoritos")
        }
    }
}
