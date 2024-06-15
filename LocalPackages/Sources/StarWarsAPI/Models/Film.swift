import Foundation

public struct Film: Codable {
    public let title: String
    public let episodeID: Int
    public let openingCrawl: String
    public let director: String
    public let producer: String
    public let releaseDate: String
    public let characters: [URL]
    public let planets: [URL]
    public let starships: [URL]
    public let vehicles: [URL]
    public let species: [URL]
    public let created: Date
    public let edited: Date
    public let url: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
}
