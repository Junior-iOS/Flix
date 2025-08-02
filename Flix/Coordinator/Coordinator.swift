//
//  Coordinator.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
    }
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
    
    // MARK: - Reusable Methods
    
    func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "Erro",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.navigationController.present(alert, animated: true)
        }
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            if actions.isEmpty {
                alert.addAction(UIAlertAction(title: "OK", style: .default))
            } else {
                actions.forEach { alert.addAction($0) }
            }
            
            self?.navigationController.present(alert, animated: true)
        }
    }
} 