//
//  ShowDetailViewController.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ShowDetailsViewController: UIViewController {
    // MARK: - Private Properties
    private(set) var detailView = ShowDetailsView()
    private let viewModel: ShowDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    private var favoriteButton: UIBarButtonItem!

    // MARK: - Init

    override func loadView() {
        view = detailView
    }

    init(viewModel: ShowDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteButton()
        bindViewModel()
        configureData()
    }
    
    // MARK: - Private Methods
    
    private func configureData() {
        title = viewModel.title
        detailView.delegate = self
        detailView.configureData(with: viewModel.show)
    }

    private func setupFavoriteButton() {
        favoriteButton = UIBarButtonItem(
            image: UIImage(icon: .heart),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func bindViewModel() {
        viewModel.isFavorite
            .drive(onNext: { [weak self] isFavorite in
                let imageName = isFavorite ? "heart.fill" : "heart"
                self?.favoriteButton.image = UIImage(systemName: imageName)
            })
            .disposed(by: disposeBag)
    }

    @objc private func favoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
}

// MARK: - ShowDetailsViewDelegate

extension ShowDetailsViewController: ShowDetailsViewDelegate {
    func didTapSeasonsButton() {
        let showSeasonsViewModel = ShowSeasonsViewModel(show: viewModel.show)
        let controller = ShowSeasonsViewController(viewModel: showSeasonsViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }

    func didTapCastButton() {
        let castViewModel = CastViewModel(show: viewModel.show)
        let controller = CastViewController(viewModel: castViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
