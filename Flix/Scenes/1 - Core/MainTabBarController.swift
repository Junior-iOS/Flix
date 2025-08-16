//
//  MainTabBarController.swift
//  Flix
//
//  Created by NJ Development on 05/06/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        // Shows Tab
        let showsNavigationController = UINavigationController(rootViewController: ShowViewController())
        showsNavigationController.tabBarItem = UITabBarItem(
            title: "Shows",
            image: UIImage(icon: .tv),
            selectedImage: UIImage(icon: .tvFill)
        )
        
        // Favorites Tab
        let favoritesNavigationController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(icon: .heart),
            selectedImage: UIImage(icon: .heartFill)
        )

        viewControllers = [showsNavigationController, favoritesNavigationController]
        selectedIndex = 0
        
        tabBar.tintColor = .label
        overrideUserInterfaceStyle = .dark
    }
} 
