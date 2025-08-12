//
//  ShowSeasonsViewController.swift
//  Flix
//
//  Created by NJ Development on 09/08/25.
//

import Foundation
import UIKit
import RxSwift

final class ShowSeasonsViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: ShowSeasonsViewModelProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Inirt
    init(viewModel: ShowSeasonsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchSeasons()
    }

    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.seasonsSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] seasons in
                print("🎬 Recebi temporadas:", seasons)
                print("Número de temporadas:", seasons.count)
                // Atualizar UI aqui
            })
            .disposed(by: disposeBag)
    }
}
