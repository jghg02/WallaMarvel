import Foundation

protocol GetHeroByIdUseCaseProtocol {
    func execute(heroId: Int, completionBlock: @escaping (Result<CharacterDataModel?, MarvelAPIError>) -> Void)
}

final class GetHeroById: GetHeroByIdUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
    func execute(heroId: Int, completionBlock: @escaping (Result<CharacterDataModel?, MarvelAPIError>) -> Void) {
        repository.getHeroById(heroId) { result in
            switch result {
            case .success(let container):
                // Return the first character from the container (should be the specific hero)
                let hero = container.characters.first
                completionBlock(.success(hero))
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
}
