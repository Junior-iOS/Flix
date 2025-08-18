//
//  EpisodesViewModel.swift
//  Flix
//
//  Created by NJ Development on 17/08/25.
//

import UIKit

final class DetailsEpisodeViewController: UIViewController {
    
    // MARK: - Properties
    private let detailsEpisodeView = DetailsEpisodeView()
    private let viewModel: DetailsEpisodeViewModelProtocol
    
    // MARK: - Init
    override func loadView() {
        super.loadView()
        view = detailsEpisodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    init(viewModel: DetailsEpisodeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    private func configureUI() {
        title = viewModel.title
        overrideUserInterfaceStyle = .dark
        detailsEpisodeView.configure(episode: viewModel.episode)
    }
}
