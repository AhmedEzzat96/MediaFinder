import Foundation
import UIKit
import SQLite

public enum MediaType: String {
    case tvShow
    case music
    case movie
    case all
}

struct Media: Decodable {
    let trackName: String?
    let artistName: String!
    let artworkUrl100: String!
    let previewUrl: String?
    let longDescription: String?
    let kind: String?
    
    func getKind() -> MediaType {
        switch self.kind {
        case "song":
            return MediaType.music
        case "feature-movie":
            return MediaType.movie
        case "tv-episode":
            return MediaType.tvShow
        default:
            return MediaType.music
        }
    }
}

