//
//  HeroesCoordinator.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import UIKit
import SwiftUI

protocol HeroesCoordinatorDelegate: AnyObject {
    func heroesCoordinatorDidFinish(_ coordinator: HeroesCoordinator)
}

/// Coordinator responsible for the Heroes flow (list and detail)
final class HeroesCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: HeroesCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setupMarvelAppearance()
    }
    
    func start() {
        showHeroesList()
    }
    
    private func showHeroesList() {
        let viewModel = ListHeroesViewModel()
        viewModel.coordinator = self
        
        let heroesListView = ListHeroesSwiftUIView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: heroesListView)
        
        hostingController.title = "Marvel Heroes"
        
        // Observe title changes from ViewModel
        viewModel.$searchText
            .combineLatest(viewModel.$heroes)
            .sink { [weak hostingController] searchText, heroes in
                DispatchQueue.main.async {
                    if searchText.isEmpty {
                        hostingController?.title = "Marvel Heroes"
                    } else {
                        hostingController?.title = "Search Results (\(heroes.count))"
                    }
                }
            }
            .store(in: &viewModel.cancellables)
        
        navigationController.pushViewController(hostingController, animated: false)
    }
    
    func showHeroDetail(for hero: CharacterDataModel) {
        let detailViewModel = HeroDetailViewModel(hero: hero)
        detailViewModel.coordinator = self
        
        let heroDetailView = HeroDetailView(viewModel: detailViewModel)
        let hostingController = UIHostingController(rootView: heroDetailView)
        hostingController.title = hero.name
        
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func dismissHeroDetail() {
        navigationController.popViewController(animated: true)
    }
}
