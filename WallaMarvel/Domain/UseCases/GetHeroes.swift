import Foundation

protocol GetHeroesUseCaseProtocol {
    func execute(limit: Int, offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
}

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
    func execute(limit: Int = 20, offset: Int = 0, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        repository.getHeroes(limit: limit, offset: offset, completionBlock: completionBlock)
    }
}
