//
//  EpisodesViewController.swift
//  Flix
//
//  Created by NJ Development on 15/08/25.
//

import UIKit
import RxSwift

final class EpisodesViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: EpisodesViewModelProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        bindViewModel()
    }
    
    init(viewModel: EpisodesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    private func bindViewModel() {
        viewModel.episodesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] episodes in
                guard let self = self else { return }
                // Atualize a UI com os episódios recebidos
                print("Received episodes: \(episodes.count)")
                print("Episodes: \(episodes.map { $0 })")
            })
            .disposed(by: disposeBag)
    }
}
