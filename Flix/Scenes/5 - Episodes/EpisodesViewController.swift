//
//  EpisodesViewController.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import UIKit
import RxSwift

final class EpisodesViewController: UIViewController {
    
    // MARK: - Private Properties
    private let episodesView = EpisodesView()
    private let viewModel: EpisodesViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private lazy var header: EpisodesHeaderView = {
        let header = EpisodesHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override func loadView() {
        view = episodesView
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        bindViewModel()
//        setupHeader()
        setupTable()
    }
    
    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    private func bindViewModel() {
        viewModel.episodesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] episodes in
                guard let self = self else { return }
                // Atualize a UI com os episódios recebidos
                print("Received episodes: \(episodes.count)")
                print("Episodes: \(episodes.map { $0 })")
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTable() {
        episodesView.tableView.delegate = self
        episodesView.tableView.dataSource = self
        episodesView.tableView.showsVerticalScrollIndicator = false
        
        header = EpisodesHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        header.configure(with: viewModel.season)
        episodesView.tableView.tableHeaderView = header
    }
}

// MARK: - UITABLEVIEW DELEGATE AND DATASOURCE
extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Title For Header" // sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}

// MARK: - COLLECTIONVIEWTABLEVIEWCELL DELEGATE
//extension HomeViewController: CollectionViewTableViewCellDelegate {
//    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewViewModel) {
//        DispatchQueue.main.async {
//            cell.activityIndicator.stopAnimating()
//            let controller = PreviewViewController()
//            controller.configure(with: viewModel)
//            self.present(controller, animated: true)
//        }
//    }
//    
//    func networkError(_ cell: CollectionViewTableViewCell) {
//        DispatchQueue.main.async {
//            cell.activityIndicator.stopAnimating()
//            self.showMessage(withTitle: "Ops!", message: "Something went wrong.\nTry again later!")
//        }
//    }
//}
//
//extension HomeViewController: viewModelDelegate {
//    func showError(_ error: NetworkError) {
//        self.showMessage(withTitle: "Ops!", message: error.localizedDescription)
//    }
//}
