//
//  APIClientTest.swift
//  WallaMarvelTests
//
//  Created by Josue Hernandez on 6/11/25.
//

import XCTest
@testable import WallaMarvel
import Foundation

final class APIClientTest: XCTestCase {
    
    // MARK: - Properties
    
    var apiClient: APIClient!
    var mockURLSession: MockURLSession!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiClient = APIClient(session: mockURLSession)
    }
    
    override func tearDown() {
        apiClient = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - Tests for getHeroes
    
    func testGetHeroes_Success() {
        // Given
        let mockJSONString = """
        {
            "data": {
                "count": 3,
                "total": 100,
                "limit": 20,
                "offset": 0,
                "results": [
                    {
                        "id": 1009610,
                        "name": "Spider-Man",
                        "description": "Bitten by a radioactive spider, high school student Peter Parker gained the speed, strength and powers of a spider.",
                        "thumbnail": {
                            "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/50/526548a343e4b",
                            "extension": "jpg"
                        },
                        "comics": {
                            "available": 100,
                            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1009610/comics"
                        },
                        "series": {
                            "available": 50,
                            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1009610/series"
                        },
                        "stories": {
                            "available": 200,
                            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1009610/stories"
                        },
                        "events": {
                            "available": 25,
                            "collectionURI": "http://gateway.marvel.com/v1/public/characters/1009610/events"
                        },
                        "urls": [
                            {
                                "type": "detail",
                                "url": "http://marvel.com/characters/54/spider-man"
                            }
                        ]
                    }
                ]
            }
        }
        """
        
        let mockData = mockJSONString.data(using: .utf8)!
        
        mockURLSession.mockData = mockData
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://gateway.marvel.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "API call completes")
        var result: Result<CharacterDataContainer, MarvelAPIError>?
        
        // When
        apiClient.getHeroes(limit: 20, offset: 0) { apiResult in
            result = apiResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success(let container):
            XCTAssertEqual(container.characters.count, 1)
            XCTAssertEqual(container.characters.first?.name, "Spider-Man")
            XCTAssertEqual(container.limit, 20)
            XCTAssertEqual(container.offset, 0)
        case .failure(let error):
            XCTFail("Expected success but got error: \(error)")
        case .none:
            XCTFail("No result received")
        }
    }
    
    func testGetHeroes_NetworkError() {
        // Given
        mockURLSession.mockError = NSError(domain: "TestDomain", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
        
        let expectation = expectation(description: "API call completes")
        var result: Result<CharacterDataContainer, MarvelAPIError>?
        
        // When
        apiClient.getHeroes(limit: 20, offset: 0) { apiResult in
            result = apiResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .networkError(let underlyingError) = error {
                XCTAssertEqual((underlyingError as NSError).code, -1009)
            } else {
                XCTFail("Expected network error but got: \(error)")
            }
        case .none:
            XCTFail("No result received")
        }
    }
    
    func testGetHeroes_InvalidStatusCode() {
        // Given
        mockURLSession.mockData = Data()
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://gateway.marvel.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "API call completes")
        var result: Result<CharacterDataContainer, MarvelAPIError>?
        
        // When
        apiClient.getHeroes(limit: 20, offset: 0) { apiResult in
            result = apiResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .invalidResponse(let statusCode) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected invalid response error but got: \(error)")
            }
        case .none:
            XCTFail("No result received")
        }
    }
    
    func testGetHeroes_DecodingError() {
        // Given
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        mockURLSession.mockData = invalidJSON
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://gateway.marvel.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = expectation(description: "API call completes")
        var result: Result<CharacterDataContainer, MarvelAPIError>?
        
        // When
        apiClient.getHeroes(limit: 20, offset: 0) { apiResult in
            result = apiResult
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1.0)
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            if case .decodingError = error {
                XCTAssertTrue(true, "Correctly identified decoding error")
            } else {
                XCTFail("Expected decoding error but got: \(error)")
            }
        case .none:
            XCTFail("No result received")
        }
    }
    
}

// MARK: - Mock Classes

class MockURLSession: URLSession {
    
    // MARK: - Properties
    
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var lastRequest: URLRequest?
    
    // MARK: - URLSession Override
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        lastRequest = request
        return MockURLSessionDataTask {
            completionHandler(self.mockData, self.mockResponse, self.mockError)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    
    // MARK: - Properties
    
    private let closure: () -> Void
    
    // MARK: - Initialization
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    // MARK: - URLSessionDataTask Override
    
    override func resume() {
        closure()
    }
}
