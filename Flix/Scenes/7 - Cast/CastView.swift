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
    enum Section {
        case main
    }

    let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, Cast>?
    var onSelectCast: ((Int) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Private Methods
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CastCell.self, forCellReuseIdentifier: CastCell.identifier)
        tableView.delegate = self
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
        dataSource = UITableViewDiffableDataSource<Section, Cast>(
            tableView: tableView
        ) { tableView, indexPath, cast in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CastCell.identifier,
                for: indexPath
            ) as? CastCell else {
                return UITableViewCell()
            }
            cell.configure(with: cast)
            return cell
        }
    }

    // MARK: - Public Methods
    func apply(_ cast: [Cast], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cast>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cast)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UITableViewDelegate
extension CastView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectCast?(indexPath.row)
    }
}
