import Foundation

struct Thumbnail: Decodable {
    let path: String
    let `extension`: String
    
    var url: URL? {
        let urlString = "\(path).\(`extension`)"
        return URL(string: urlString)
    }
}
