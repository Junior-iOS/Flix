//
//  ViewController.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import RxSwift
import UIKit

final class ShowViewController: UIViewController {
    private let viewModel: ShowViewModelProtocol
    private let showView = ShowView()
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let networkMonitor = NetworkMonitor.shared

    // MARK: - Init
    init(viewModel: ShowViewModelProtocol = ShowViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    override func loadView() {
        super.loadView()
        self.view = showView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBarAndDelegatesAndDataSources()
        setupBindings()
    }

    // MARK: - Private Methods
    private func configNavBarAndDelegatesAndDataSources() {
        configureNavigationBar()
        configureRefreshControl()
        configureDelegates()
        configureDataSource()
    }

    private func setupBindings() {
        disposeBag.insert([
            viewModel.shows
                .drive { [weak self] shows in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(shows)
                    DispatchQueue.main.async {
                        self?.showView.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                    self?.setNeedsUpdateContentUnavailableConfiguration()
                },

            viewModel.isLoading
                .drive { [weak self] isLoading in
                    DispatchQueue.main.async {
                        if isLoading {
                            self?.showView.activityIndicator.startAnimating()
                        } else {
                            self?.showView.activityIndicator.stopAnimating()
                        }
                    }
                }
        ])
    }

    private func configureNavigationBar() {
        title = "TV Shows"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar por séries de TV"
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        // Estilo da barra de busca para branco
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .label
        searchController.searchBar.searchTextField.textColor = .label
        searchController.searchBar.searchTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.2)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando shows...")
        refreshControl.tintColor = .systemOrange
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        showView.collectionView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão - cancelando refresh")
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
            return
        }

        viewModel.showSubject
            .subscribe { [weak self] _ in
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }

    private func configureDelegates() {
        showView.collectionView.delegate = self
    }

    private func configureDataSource() {
        showView.dataSource = UICollectionViewDiffableDataSource<Section, TVShow>(
            collectionView: showView.collectionView) { collectionView, indexPath, show -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShowCell.identifier,
                    for: indexPath
                ) as? ShowCell else {
                    print("Dequeue Reusable Cell Falhou")
                    return UICollectionViewCell()
                }
            cell.configure(show: show)
            return cell
        }
    }

    override func updateContentUnavailableConfiguration(using _: UIContentUnavailableConfigurationState) {
        if viewModel.numberOfItemsInSection == 0 { /*&& !showView.spinner.isAnimating*/
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "movieclapper")
            config.text = "Sem Séries"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 { // perto do final
            viewModel.loadNextPage()
        }
    }
}

// MARK: COLLECTIONVIEW DELEGATE
extension ShowViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = viewModel.cellForItem(at: indexPath)
        let showDetailsViewModel = ShowDetailsViewModel(show: show)
        let controller = ShowDetailsViewController(viewModel: showDetailsViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: SEARCH BAR
extension ShowViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            viewModel.searchBar(textDidChange: "")
            return
        }
        viewModel.searchBar(textDidChange: filter)
    }
}

// MARK: - UISearchBarDelegate
extension ShowViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchBar(textDidChange: "")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBar(textDidChange: searchText)
    }
}
