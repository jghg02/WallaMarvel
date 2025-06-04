//
//  AppCoordinator.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import UIKit

/// Main application coordinator that manages the overall navigation flow
final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHeroesList()
    }
    
    private func showHeroesList() {
        let heroesCoordinator = HeroesCoordinator(navigationController: navigationController)
        heroesCoordinator.delegate = self
        childCoordinators.append(heroesCoordinator)
        heroesCoordinator.start()
    }
}

// MARK: - HeroesCoordinatorDelegate
extension AppCoordinator: HeroesCoordinatorDelegate {
    func heroesCoordinatorDidFinish(_ coordinator: HeroesCoordinator) {
        childDidFinish(coordinator)
    }
}
