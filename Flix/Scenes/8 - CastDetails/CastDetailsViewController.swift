//
//  CastDetailsViewController.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import UIKit

final class CastDetailsViewController: UIViewController {
    // MARK: - Private Properties
    private let viewModel: CastDetailsViewModelProtocol
    private let castDetailsView = CastDetailsView()
    
    // MARK: - Init
    init(viewModel: CastDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = castDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        castDetailsView.configure(with: viewModel)
    }
}
