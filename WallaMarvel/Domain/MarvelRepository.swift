import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(limit: Int, offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
}

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelDataSourceProtocol
    
    init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(limit: Int = 20, offset: Int = 0, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        dataSource.getHeroes(limit: limit, offset: offset, completionBlock: completionBlock)
    }
    
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        dataSource.getHeroById(id, completionBlock: completionBlock)
    }
}
