//
//  ShowsCoordinator.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class ShowsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ShowViewModel()
        let viewController = ShowViewController(viewModel: viewModel)
        
        // Configura as referências do coordinator
        viewController.coordinator = self
        viewModel.coordinator = self
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    // MARK: - Navigation Methods
    
    func showShowDetail(show: TVShow) {
        print("📱 Navegando para detalhes do show: \(show.name)")
        
        let detailCoordinator = ShowDetailCoordinator(navigationController: navigationController, show: show)
        addChild(detailCoordinator)
        detailCoordinator.start()
    }
    
    func showNoConnectionAlert() {
        showAlert(
            title: "Sem Conexão",
            message: "Verifique sua conexão com a internet e tente novamente."
        )
    }
} 
