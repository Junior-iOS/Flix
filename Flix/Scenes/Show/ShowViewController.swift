//
//  ViewController.swift
//  Flix
//
//  Created by NJ Development on 23/05/25.
//

import UIKit
import RxSwift

final class ShowViewController: UIViewController {
    private let viewModel: ShowViewModel
    private let showView = ShowView()
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    private let networkMonitor = NetworkMonitor.shared

    // MARK: - Init
    init(viewModel: ShowViewModel = ShowViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    override func loadView() {
        super.loadView()
        self.view = showView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBarAndDelegatesAndDataSources()
        setupBindings()
        fetchShows()
    }
    
    private func fetchShows() {
        viewModel.fetchTVShows()
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func configNavBarAndDelegatesAndDataSources() {
        configureNavigationBar()
        configureRefreshControl()
        configureDelegates()
        configureDataSource()
    }
    
    private func setupBindings() {
        disposeBag.insert([
            viewModel.shows
                .drive(onNext: { [weak self] shows in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, TVShow>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(shows)
                    DispatchQueue.main.async {
                        self?.showView.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                    self?.setNeedsUpdateContentUnavailableConfiguration()
                }),
            
            viewModel.isLoading
                .drive(onNext: { [weak self] isLoading in
                    DispatchQueue.main.async {
                        if isLoading {
                            self?.showView.activityIndicator.startAnimating()
                        } else {
                            self?.showView.activityIndicator.stopAnimating()
                        }
                    }
                })
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
    }
    
    private func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando shows...")
        refreshControl.tintColor = .systemOrange
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        showView.collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        print("🔄 Pull-to-refresh iniciado")
        
        // Verifica conectividade antes de fazer refresh
        guard networkMonitor.checkConnection() else {
            print("❌ Sem conexão - cancelando refresh")
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl.endRefreshing()
            }
//            coordinator?.showNoConnectionAlert()
            return
        }
        
        viewModel.refreshData()
            .subscribe(onSuccess: { [weak self] _ in
                print("✅ Pull-to-refresh concluído com sucesso")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }, onFailure: { [weak self] error in
                print("❌ Pull-to-refresh falhou: \(error)")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureDelegates() {
        showView.collectionView.delegate = self
    }
    
    private func configureDataSource() {
        showView.dataSource = UICollectionViewDiffableDataSource<Section, TVShow>(
            collectionView: showView.collectionView,
            cellProvider: { (collectionView, indexPath, show) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShowCell.identifier,
                    for: indexPath
                ) as? ShowCell else {
                    print("Dequeue Reusable Cell Falhou")
                    return UICollectionViewCell()
                }
            cell.configure(show: show)
            return cell
        })
    }
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if viewModel.numberOfItemsInSection == 0 /*&& !showView.spinner.isAnimating*/ {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "movieclapper")
            config.text = "Sem Séries"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
}

//MARK: COLLECTIONVIEW DELEGATE
extension ShowViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = viewModel.cellForItem(at: indexPath)
        
        // Usa o coordinator para navegação
//        coordinator?.showShowDetail(show: show)
        let controller = ShowDetailViewController(show: show)
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

extension ShowViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("🔘 SearchBar Cancel button clicked")
        // Quando o cancel é pressionado, limpa a busca
        searchBar.text = ""
        viewModel.searchBar(textDidChange: "")
        
        // Só refaz o fetch se realmente não temos dados originais
        if viewModel.shouldRefetchData() {
            print("🔄 Refazendo fetch - não há dados originais")
            fetchShows()
        } else {
            print("✅ Não refazendo fetch - já temos dados originais")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Esconde o teclado quando a busca é confirmada
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Atualiza a busca em tempo real
        viewModel.searchBar(textDidChange: searchText)
    }
}
