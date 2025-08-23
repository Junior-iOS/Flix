//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController {
    // MARK: - Properties
    private let detailsEpisodeView = EpisodeDetailsView()
    private let viewModel: EpisodeDetailsViewModelProtocol

    // MARK: - Init
    override func loadView() {
        view = detailsEpisodeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    init(viewModel: EpisodeDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    // MARK: - Private Methods
    private func configureUI() {
        title = viewModel.title
        overrideUserInterfaceStyle = .dark
        detailsEpisodeView.configure(with: viewModel.episode)
    }
}
