//
//  ListHeroesViewModel.swift
//  WallaMarvel
//
//  Created by Josue Hernandez on 6/2/25.
//

import Foundation
import Combine

final class ListHeroesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var heroes: [CharacterDataModel] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // MARK: - Search Properties
    private var allHeroes: [CharacterDataModel] = [] // Store all loaded heroes
    
    // MARK: - Pagination Properties
    private var currentOffset: Int = 0
    private let pageSize: Int = 20
    private var totalCount: Int = 0
    private var hasMorePages: Bool = true
    
    // MARK: - Dependencies
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Coordinator
    weak var coordinator: HeroesCoordinator?
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
        
        // Setup search functionality
        setupSearchBinding()
    }
    
    // MARK: - Public Methods
    
    /// Fetch heroes from the beginning (refresh)
    func fetchHeroes() {
        resetPagination()
        loadHeroes(isRefresh: true)
    }
    
    /// Load more heroes (pagination)
    func loadMoreHeroes() {
        guard !isLoading && !isLoadingMore && hasMorePages else { 
            print("Cannot load more: isLoading=\(isLoading), isLoadingMore=\(isLoadingMore), hasMorePages=\(hasMorePages)")
            return 
        }
        
        print("Loading more heroes: offset=\(currentOffset), pageSize=\(pageSize)")
        loadHeroes(isRefresh: false)
    }
    
    /// Check if we should load more when reaching near the end
    func shouldLoadMore(currentItem: CharacterDataModel) -> Bool {
        // Use filteredHeroes for pagination logic when searching
        let heroesToCheck = searchText.isEmpty ? allHeroes : filteredHeroes
        guard let index = heroesToCheck.firstIndex(where: { $0.id == currentItem.id }) else { 
            print("Could not find index for hero: \(currentItem.name)")
            return false 
        }
        
        // Only load more if we're not searching and we're near the end of all heroes
        let threshold = 5 // Load more when we're 5 items from the end
        let shouldLoad = searchText.isEmpty && 
                        index >= allHeroes.count - threshold && 
                        hasMorePages && 
                        !isLoading && 
                        !isLoadingMore
        
        if shouldLoad {
            print("Should load more: index=\(index), count=\(allHeroes.count), threshold=\(threshold), hasMore=\(hasMorePages)")
        }
        
        return shouldLoad
    }
    
    var screenTitle: String {
        _ = searchText.isEmpty ? allHeroes.count : filteredHeroes.count
        let totalCount = searchText.isEmpty ? allHeroes.count : allHeroes.count
        
        if searchText.isEmpty {
            if allHeroes.isEmpty {
                return "Heroes"
            } else {
                return "Heroes (\(allHeroes.count))"
            }
        } else {
            return "Heroes (\(filteredHeroes.count) of \(totalCount))"
        }
    }
    
    func retryFetchHeroes() {
        fetchHeroes()
    }
    
    func clearHeroes() {
        heroes = []
        allHeroes = []
        errorMessage = nil
        resetPagination()
    }
    
    // MARK: - Search Methods
    func clearSearch() {
        searchText = ""
    }
    
    // MARK: - Navigation
    func didSelectHero(_ hero: CharacterDataModel) {
        coordinator?.showHeroDetail(for: hero)
    }
    
    // MARK: - Private Methods
    
    private func resetPagination() {
        currentOffset = 0
        totalCount = 0
        hasMorePages = true
        heroes = []
        allHeroes = []
    }
    
    private func loadHeroes(isRefresh: Bool) {
        if isRefresh {
            isLoading = true
        } else {
            isLoadingMore = true
        }
        
        errorMessage = nil
        
        getHeroesUseCase.execute(limit: pageSize, offset: currentOffset) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.isLoadingMore = false
                
                switch result {
                case .success(let characterDataContainer):
                    self?.handleSuccessResponse(characterDataContainer, isRefresh: isRefresh)
                    
                case .failure(let error):
                    self?.handleErrorResponse(error, isRefresh: isRefresh)
                }
            }
        }
    }
    
    private func handleSuccessResponse(_ container: CharacterDataContainer, isRefresh: Bool) {
        let newHeroes = container.characters
        
        if isRefresh {
            allHeroes = newHeroes
        } else {
            allHeroes.append(contentsOf: newHeroes)
        }
        
        // Update heroes to show the filtered results
        heroes = filteredHeroes
        
        // Update pagination info - use 'total' for pagination logic, not 'count'
        totalCount = container.total
        currentOffset += newHeroes.count
        hasMorePages = currentOffset < totalCount
        
        errorMessage = nil
    }
    
    private func handleErrorResponse(_ error: MarvelAPIError, isRefresh: Bool) {
        errorMessage = error.localizedDescription
        
        if isRefresh {
            heroes = []
        }
        
        print("Error loading heroes: \(error.localizedDescription)")
    }
    
    // MARK: - Computed Properties
    var filteredHeroes: [CharacterDataModel] {
        if searchText.isEmpty {
            return allHeroes
        } else {
            return allHeroes.filter { hero in
                hero.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    // MARK: - Private Setup Methods
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFilteredHeroes()
            }
            .store(in: &cancellables)
    }
    
    private func updateFilteredHeroes() {
        heroes = filteredHeroes
    }
}
