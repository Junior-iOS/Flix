//
//  CastView.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit

final class CastView: UIView {
    // MARK: - Properties
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CastCell.self, forCellReuseIdentifier: CastCell.identifier)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { nil }

    private func setupView() {
        backgroundColor = .systemBackground
        addSubviews(tableView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
