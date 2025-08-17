//
//  EpisodesViewController.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import UIKit
import RxSwift
import SDWebImage

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
        title = "Episodes"
        setupTable()
    }
    
    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    private func setupTable() {
        episodesView.tableView.showsVerticalScrollIndicator = false

        header = EpisodesHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        header.configure(with: viewModel.season)
        episodesView.tableView.tableHeaderView = header

        episodesView.tableView.register(EpisodeRowCell.self, forCellReuseIdentifier: EpisodeRowCell.identifier)
        episodesView.tableView.dataSource = self
        episodesView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension EpisodesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeRowCell.identifier, for: indexPath) as? EpisodeRowCell else {
            return UITableViewCell()
        }

        cell.bind(to: viewModel.episodesRelay.asObservable())
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EpisodesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}
