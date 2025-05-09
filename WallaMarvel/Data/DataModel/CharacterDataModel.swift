import Foundation

struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let comics: ResourceList?
    let series: ResourceList?
    let stories: ResourceList?
    let events: ResourceList?
    let urls: [CharacterURL]?
    
    init(id: Int, name: String, description: String = "", thumbnail: Thumbnail, comics: ResourceList? = nil, series: ResourceList? = nil, stories: ResourceList? = nil, events: ResourceList? = nil, urls: [CharacterURL]? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.comics = comics
        self.series = series
        self.stories = stories
        self.events = events
        self.urls = urls
    }
}

// MARK: - Supporting Data Models

struct ResourceList: Decodable {
    let available: Int
    let collectionURI: String
    let items: [ResourceSummary]?
}

struct ResourceSummary: Decodable {
    let resourceURI: String
    let name: String
}

struct CharacterURL: Decodable {
    let type: String
    let url: String
}
