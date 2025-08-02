//
//  FavoritesCoordinator.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FavoritesViewController()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Navigation Methods
    
    func showShowDetail(show: TVShow) {
        print("📱 Navegando para detalhes do show favorito: \(show.name)")
        
        let detailCoordinator = ShowDetailCoordinator(navigationController: navigationController, show: show)
        addChild(detailCoordinator)
        detailCoordinator.start()
    }
} 