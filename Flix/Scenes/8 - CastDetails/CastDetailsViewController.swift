//
//  CastDetailsViewController.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import UIKit

class CastDetailsViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: CastDetailsViewModelProtocol
    private let castDetailsView = CastDetailsView()
    
    // MARK: - Init
    override func loadView() {
        view = castDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        castDetailsView.configure(with: viewModel.cast.person)
    }
    
    init(viewModel: CastDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        print(viewModel.cast)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}
