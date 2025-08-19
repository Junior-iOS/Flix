//
//  CastViewController.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit
import RxSwift

final class CastViewController: UIViewController {

    // MARK: - Private properties
    private let castView = CastView()
    private var viewModel: CastViewModelProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func loadView() {
        view = castView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModel()
    }

    // MARK: - Init
    init(viewModel: CastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Private Methods
    private func setup() {
        title = viewModel.title
        
        castView.onSelectCast = { [weak self] index in
            guard let self else { return }
            let person = self.viewModel.cast[index]
            let detailsVM = CastDetailsViewModel(cast: person)
            let detailsVC = CastDetailsViewController(viewModel: detailsVM)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        viewModel.fetchCast()
    }

    private func bindViewModel() {
        viewModel.castSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] cast in
                self?.viewModel.cast = cast
                self?.castView.apply(cast)
            }
            .disposed(by: disposeBag)
    }
}
