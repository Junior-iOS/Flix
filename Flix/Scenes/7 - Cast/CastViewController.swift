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
        castView.tableView.delegate = self
        castView.tableView.dataSource = self
        viewModel.fetchCast()
    }

    private func bindViewModel() {
        disposeBag.insert([
            viewModel.castSubject
                .observe(on: MainScheduler.instance)
                .subscribe { [weak self] cast in
                    self?.viewModel.cast = cast
                    self?.castView.tableView.reloadData()
                },
            
            viewModel.errorSubject
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] (error: Error) in
                    guard let self = self else { return }
                    self.showAlert(title: "Erro", message: error.localizedDescription)
                })
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cast = viewModel.cast[indexPath.row]
        let detailsVM = CastDetailsViewModel(person: cast.person)
        let detailsVC = CastDetailsViewController(viewModel: detailsVM)
        self.present(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CastCell.identifier, for: indexPath) as? CastCell else {
            return UITableViewCell()
        }
        let person = viewModel.cast[indexPath.row]
        cell.configure(with: person)
        return cell
    }
}
