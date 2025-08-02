//
//  ShowDetailCoordinator.swift
//  Flix
//
//  Created by NJ Development on 02/08/25.
//

import UIKit

final class ShowDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let show: TVShow
    
    init(navigationController: UINavigationController, show: TVShow) {
        self.navigationController = navigationController
        self.show = show
    }
    
    func start() {
        // Por enquanto, vamos criar uma tela simples de detalhes
        // Quando implementarmos a tela real, substituiremos isso
        let detailViewController = ShowDetailViewController(show: show)
        detailViewController.coordinator = self
        
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - Navigation Methods
    
    func showEpisodeList(show: TVShow) {
        print("📱 Navegando para lista de episódios do show: \(show.name)")
        
        // Implementar quando tivermos a tela de episódios
        // let episodeListCoordinator = EpisodeListCoordinator(navigationController: navigationController, show: show)
        // addChild(episodeListCoordinator)
        // episodeListCoordinator.start()
    }
    
    func showCastList(show: TVShow) {
        print("📱 Navegando para lista de elenco do show: \(show.name)")
        
        // Implementar quando tivermos a tela de elenco
        // let castListCoordinator = CastListCoordinator(navigationController: navigationController, show: show)
        // addChild(castListCoordinator)
        // castListCoordinator.start()
    }
} 