//
//  EpisodesViewController.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import RxSwift
import SDWebImage
import UIKit

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

    private struct Constants {
        static let headerHeight: CGFloat = 450
        static let heightForRow: CGFloat = 200
        static let heightForHeaderInSection: CGFloat = 40
    }

    override func loadView() {
        view = episodesView
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        setupTable()
        setupBindings()
    }

    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods
    private func setupTable() {
        episodesView.tableView.showsVerticalScrollIndicator = false

        header = EpisodesHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: Constants.headerHeight))
        header.configure(with: viewModel.season)
        episodesView.tableView.tableHeaderView = header

        episodesView.tableView.register(EpisodeRowCell.self, forCellReuseIdentifier: EpisodeRowCell.identifier)
        episodesView.tableView.dataSource = self
        episodesView.tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.onErrorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error: Error) in
                guard let self = self else { return }
                self.showAlert(title: "Error", message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension EpisodesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeRowCell.identifier, for: indexPath) as? EpisodeRowCell else {
            return UITableViewCell()
        }

        cell.bind(to: viewModel.episodesRelay.asObservable())
        cell.didSelectEpisode = { episode in
            let episodeDetailsViewModel = EpisodeViewModel(episode: episode)
            let episodeDetailsVC = EpisodeDetailsViewController(viewModel: episodeDetailsViewModel)
            self.present(episodeDetailsVC, animated: true)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EpisodesViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        Constants.heightForRow
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        Constants.heightForHeaderInSection
    }

    func tableView(_: UITableView, titleForHeaderInSection _: Int) -> String? {
        viewModel.title
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}
