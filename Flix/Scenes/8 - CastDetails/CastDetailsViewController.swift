//
//  CastDetailsViewController.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import UIKit
import SafariServices

final class CastDetailsViewController: UIViewController {
    // MARK: - Private Properties
    private let viewModel: CastDetailsViewModelProtocol
    private let castDetailsView = CastDetailsView()
    
    // MARK: - Init
    init(viewModel: CastDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func loadView() {
        view = castDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        castDetailsView.delegate = self
        castDetailsView.configure(with: viewModel)
    }
}

// MARK: - CastDetailsViewDelegate
extension CastDetailsViewController: CastDetailsViewDelegate {
    func didTapTvmaze() {
        guard let url = URL(string: viewModel.urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    func didTapWikipedia() {
        guard let url = URL(string: viewModel.wikipediaURL) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}
