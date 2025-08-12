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
        setupTabBarAppearance()
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
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
} 
