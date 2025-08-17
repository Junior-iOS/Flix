//
//  ShowDetailViewController.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class ShowDetailViewController: UIViewController {
    // MARK: - Private Properties
    private let detailView = ShowDetailsView()
    private let viewModel: ShowDetailsViewModelProtocol

    // MARK: - Init

    override func loadView() {
        view = detailView
    }

    init(_ viewModel: ShowDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }

    // MARK: - Private Methods

    private func configureData() {
        title = viewModel.title
        detailView.delegate = self
        detailView.configureData(with: viewModel.show)
    }
}

// MARK: - ShowDetailsViewDelegate

extension ShowDetailViewController: ShowDetailsViewDelegate {
    func didTapSeasonsButton() {
        let showSeasonsViewModel = ShowSeasonsViewModel(show: viewModel.show)
        let controller = ShowSeasonsViewController(viewModel: showSeasonsViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }

    func didTapCastButton() {
        print("Cast Tapped")
    }
}
