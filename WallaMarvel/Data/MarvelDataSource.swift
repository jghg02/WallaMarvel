import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes(limit: Int, offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getHeroes(limit: Int = 20, offset: Int = 0, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        return apiClient.getHeroes(limit: limit, offset: offset, completionBlock: completionBlock)
    }
    
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        return apiClient.getHeroById(id, completionBlock: completionBlock)
    }
}
