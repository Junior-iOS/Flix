//
//  CastView.swift
//  Flix
//
//  Created by NJ Development on 18/08/25.
//

import Foundation
import UIKit

final class CastView: UIView {
    enum Section {
        case main
    }

    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, Cast>!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CastCell.self, forCellReuseIdentifier: CastCell.identifier)
        tableView.rowHeight = 70
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Cast>(tableView: tableView) { tableView, indexPath, cast in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CastCell.identifier, for: indexPath) as? CastCell else {
                return UITableViewCell()
            }
            cell.configure(with: cast)
            return cell
        }
    }

    // MARK: - API
    func apply(_ casts: [Cast], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cast>()
        snapshot.appendSections([.main])
        snapshot.appendItems(casts)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
