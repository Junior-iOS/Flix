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
    private let viewModel: CastViewModelProtocol
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = castView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cast"
        bindViewModel()
        viewModel.fetchCast()
    }
    
    // MARK: - Init
    init(viewModel: CastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.castSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] cast in
                self?.castView.apply(cast)
            }
            .disposed(by: disposeBag)
    }
}
