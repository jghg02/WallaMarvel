//
//  HeroDetailViewModel.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import Foundation
import Combine

final class HeroDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var hero: CharacterDataModel
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let getHeroByIdUseCase: GetHeroByIdUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Coordinator
    weak var coordinator: HeroesCoordinator?
    
    init(hero: CharacterDataModel, getHeroByIdUseCase: GetHeroByIdUseCaseProtocol = GetHeroById()) {
        self.hero = hero
        self.getHeroByIdUseCase = getHeroByIdUseCase
        
        // Load full hero details when initialized
        loadHeroDetails()
    }
    
    // MARK: - Navigation
    func didTapBack() {
        coordinator?.dismissHeroDetail()
    }
    
    // MARK: - Computed Properties
    var heroImageURL: URL? {
        return hero.thumbnail.url
    }
    
    var heroName: String {
        return hero.name
    }
    
    // MARK: - Private Methods
    
    private func loadHeroDetails() {
        isLoading = true
        errorMessage = nil
        
        getHeroByIdUseCase.execute(heroId: hero.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let updatedHero):
                    if let updatedHero = updatedHero {
                        self?.hero = updatedHero
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    func retryLoading() {
        loadHeroDetails()
    }
}
