import Foundation

/// Custom error types for Marvel API
enum MarvelAPIError: Error, LocalizedError {
    case networkError(Error)
    case invalidResponse(Int)
    case decodingError(Error)
    case invalidURL
    case noData
    case authenticationError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Invalid response from server (Status: \(statusCode))"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .authenticationError:
            return "Authentication failed with Marvel API"
        }
    }
}

/// Marvel API endpoint definitions
enum MarvelEndpoint {
    case characters
    case character(id: Int)
    
    var path: String {
        switch self {
        case .characters:
            return "/v1/public/characters"
        case .character(let id):
            return "/v1/public/characters/\(id)"
        }
    }
}

/// Marvel API request parameters
struct MarvelRequestParameters {
    let limit: Int?
    let offset: Int?
    let characterId: Int?
    let nameStartsWith: String?
    
    static func forCharactersList(limit: Int = 20, offset: Int = 0, nameStartsWith: String? = nil) -> MarvelRequestParameters {
        return MarvelRequestParameters(limit: limit, offset: offset, characterId: nil, nameStartsWith: nameStartsWith)
    }
    
    static func forCharacter(id: Int) -> MarvelRequestParameters {
        return MarvelRequestParameters(limit: nil, offset: nil, characterId: id, nameStartsWith: nil)
    }
}

protocol APIClientProtocol {
    func getHeroes(limit: Int, offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
    func searchHeroes(nameStartsWith: String, limit: Int, offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void)
}

final class APIClient: APIClientProtocol {
    
    // MARK: - Constants
    
    private enum Constant {
        static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        static let publicKey = "d575c26d5c746f623518e753921ac847"
        static let baseURL = "https://gateway.marvel.com:443"
        static let timeoutInterval: TimeInterval = 30.0
    }
    
    // MARK: - Properties
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        
        // Configure decoder if needed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    // MARK: - Public Methods
    
    func getHeroes(limit: Int = 20, offset: Int = 0, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        let parameters = MarvelRequestParameters.forCharactersList(limit: limit, offset: offset)
        performRequest(endpoint: .characters, parameters: parameters, completionBlock: completionBlock)
    }
    
    func getHeroById(_ id: Int, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        let parameters = MarvelRequestParameters.forCharacter(id: id)
        performRequest(endpoint: .characters, parameters: parameters, completionBlock: completionBlock)
    }
    
    // MARK: - Future extensibility methods
    
    /// Search heroes by name (can be easily extended in the future)
    func searchHeroes(nameStartsWith: String, limit: Int = 20, offset: Int = 0, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        let parameters = MarvelRequestParameters.forCharactersList(limit: limit, offset: offset, nameStartsWith: nameStartsWith)
        performRequest(endpoint: .characters, parameters: parameters, completionBlock: completionBlock)
    }
    
    // MARK: - Private Methods
    
    /// Performs a network request to the Marvel API
    /// - Parameters:
    ///   - endpoint: The API endpoint to call
    ///   - parameters: The request parameters
    ///   - completionBlock: Completion handler with result
    private func performRequest(endpoint: MarvelEndpoint, parameters: MarvelRequestParameters, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        
        // Build URL
        guard let url = buildURL(endpoint: endpoint, parameters: parameters) else {
            completionBlock(.failure(.invalidURL))
            return
        }
        
        #if DEBUG
        print("Marvel API Request: \(url.absoluteString)")
        #endif
        
        // Create request
        let request = createURLRequest(url: url)
        
        // Perform network call
        session.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, completionBlock: completionBlock)
        }.resume()
    }
    
    private func buildURL(endpoint: MarvelEndpoint, parameters: MarvelRequestParameters) -> URL? {
        guard var urlComponents = URLComponents(string: Constant.baseURL + endpoint.path) else {
            return nil
        }
        
        // Generate authentication parameters
        let authParams = generateAuthenticationParameters()
        
        // Build query parameters
        var queryItems = authParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Add specific parameters
        if let limit = parameters.limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        if let offset = parameters.offset {
            queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
        }
        
        if let characterId = parameters.characterId {
            queryItems.append(URLQueryItem(name: "id", value: String(characterId)))
        }
        
        if let nameStartsWith = parameters.nameStartsWith, !nameStartsWith.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    private func generateAuthenticationParameters() -> [String: String] {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let hash = "\(timestamp)\(Constant.privateKey)\(Constant.publicKey)".md5
        
        return [
            "apikey": Constant.publicKey,
            "ts": timestamp,
            "hash": hash
        ]
    }
    
    private func createURLRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = Constant.timeoutInterval
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("WallaMarvel/1.0", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completionBlock: @escaping (Result<CharacterDataContainer, MarvelAPIError>) -> Void) {
        
        // Handle network error
        if let error = error {
            completionBlock(.failure(.networkError(error)))
            return
        }
        
        // Check if we have data
        guard let data = data else {
            completionBlock(.failure(.noData))
            return
        }
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            completionBlock(.failure(.invalidResponse(0)))
            return
        }
        
        // Check status code
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 401 {
                completionBlock(.failure(.authenticationError))
            } else {
                completionBlock(.failure(.invalidResponse(httpResponse.statusCode)))
            }
            return
        }
        
        // Decode the response
        do {
            let dataModel = try decoder.decode(CharacterDataContainer.self, from: data)
            #if DEBUG
            print("Marvel API Success: Received \(dataModel.characters.count) characters")
            #endif
            completionBlock(.success(dataModel))
        } catch {
            #if DEBUG
            print("Marvel API Decode Error: \(error)")
            #endif
            completionBlock(.failure(.decodingError(error)))
        }
    }
}

// MARK: - APIClient + Future Extensions

extension APIClient {
    
    /// Configuration for API client behavior
    enum Configuration {
        static let maxRetryAttempts = 3
        static let retryDelay: TimeInterval = 1.0
    }
    
}
