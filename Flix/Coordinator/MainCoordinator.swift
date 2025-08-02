//
//  MainCoordinator.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = MainTabBarController()
        navigationController.setViewControllers([tabBarController], animated: false)
        
        // Configura os coordinators filhos
        setupChildCoordinators()
    }
    
    private func setupChildCoordinators() {
        // Shows Coordinator
        let showsCoordinator = ShowsCoordinator(navigationController: navigationController)
        addChild(showsCoordinator)
        showsCoordinator.start()
        
        // Favorites Coordinator
        let favoritesCoordinator = FavoritesCoordinator(navigationController: navigationController)
        addChild(favoritesCoordinator)
        favoritesCoordinator.start()
    }
} 
