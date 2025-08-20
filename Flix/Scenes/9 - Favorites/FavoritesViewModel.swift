//
//  FavoritesViewController.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import Foundation
import RxSwift

protocol FavoritesViewModelDelegate: AnyObject {
    func reloadTable()
}

protocol FavoritesViewModelProtocol {
    func cellForRow(at indexPath: IndexPath) -> TVShow
    func loadShows()
    func saveShows()
    func removeShow(at index: Int)
    func setDelegate(_ delegate: FavoritesViewModelDelegate)
    var numberOfRowsInSection: Int { get }
    var title: String { get }
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    // MARK: - Private Properties
    private var shows: [TVShow] = []
    private let service = Service()
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    weak var delegate: FavoritesViewModelDelegate?
    var title: String { "Favorites" }
    
    // MARK: - Init
    init() {
        loadShows()
    }
    
    // MARK: - Private Methods
    var numberOfRowsInSection: Int {
        shows.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> TVShow {
        return shows[indexPath.row]
    }
    
    func loadShows() {
        guard let data = UserDefaults.standard.data(forKey: "favorites"),
              let ids = try? JSONDecoder().decode([Int].self, from: data),
              !ids.isEmpty else {
            shows = []
            delegate?.reloadTable()
            return
        }

        let shows = ids.map { service.getShow(id: $0) }
        Single.zip(shows)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] fetchedShows in
                self?.shows = fetchedShows
                self?.delegate?.reloadTable()
            }, onFailure: { [weak self] _ in
                self?.shows = []
                self?.delegate?.reloadTable()
            })
            .disposed(by: disposeBag)
    }

    func saveShows() {
        let ids = shows.map { $0.id }
        if let data = try? JSONEncoder().encode(ids) {
            UserDefaults.standard.set(data, forKey: "favorites")
        }
    }

    func removeShow(at index: Int) {
        shows.remove(at: index)
        saveShows()
        delegate?.reloadTable()
    }
    
    func setDelegate(_ delegate: FavoritesViewModelDelegate) {
        self.delegate = delegate
    }
}
