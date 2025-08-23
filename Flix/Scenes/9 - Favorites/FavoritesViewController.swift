//
//  FavoritesViewController.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import UIKit
import RxRelay
import RxSwift

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private let favoritesView = FavoritesView()
    private var viewModel: FavoritesViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private var sortedShows: [TVShow] {
        (0..<viewModel.numberOfRowsInSection).map {
            viewModel.cellForRow(at: IndexPath(row: $0, section: 0))
        }.sorted {
            $0.name < $1.name
        }
    }
    
    // MARK: - Init
    override func loadView() {
        view = favoritesView
    }
    
    init(viewModel: FavoritesViewModelProtocol = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDelegatesAndDataSources()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadShows()
        setNeedsUpdateContentUnavailableConfiguration()
    }
    
    // MARK: - Private Methods
    private func configureNavigationBar() {
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureDelegatesAndDataSources() {
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
        favoritesView.tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.identifier)
        viewModel.setDelegate(self)
    }
    
    // MARK: - Public Methods
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if sortedShows.count == 0 {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(icon: .star)
            config.text = "No Favorites Yet"
            config.secondaryText = "Your favorite shows will appear here."
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
}

// MARK: - UITableViewDelegates / DataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as? FavoritesCell else { return UITableViewCell() }
        let show = sortedShows[indexPath.row]
        cell.configure(show: show)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let show = sortedShows[indexPath.row]
        let detailsViewModel = ShowDetailsViewModel(show: show)
        let detailVC = ShowDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard indexPath.row < sortedShows.count else { return }
            let showToRemove = sortedShows[indexPath.row]
            if let originalIndex = (0..<viewModel.numberOfRowsInSection).first(where: {
                viewModel.cellForRow(at: IndexPath(row: $0, section: 0)).name == showToRemove.name
            }) {
                viewModel.removeShow(at: originalIndex)
                viewModel.saveShows()
                setNeedsUpdateContentUnavailableConfiguration()
            }
        }
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func reloadTable() {
        favoritesView.tableView.reloadData()
        setNeedsUpdateContentUnavailableConfiguration()
    }
}
