//
//  ShowDetailViewController.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class ShowDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    private let show: TVShow
    private let detailView = ShowDetailsView()
    
    // MARK: - Init
    
    override func loadView() {
        view = detailView
    }
    
    init(show: TVShow) {
        self.show = show
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }
    
    // MARK: - Private Methods
    
    private func configureData() {
        title = show.name
        detailView.delegate = self
        detailView.configureData(with: show)
    }
}

// MARK: - ShowDetailsViewDelegate

extension ShowDetailViewController: ShowDetailsViewDelegate {
    func didTapSeasonsButton() {
        print("Seasons Tapped")
    }
    
    func didTapCastButton() {
        print("Cast Tapped")
    }
}
