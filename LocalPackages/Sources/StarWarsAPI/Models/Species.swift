import Foundation

public struct Species: Codable {
    public let name: String
    public let classification: String
    public let designation: String
    public let averageHeight: String
    public let skinColors: String
    public let hairColors: String
    public let eyeColors: String
    public let averageLifespan: String
    public let homeworld: String
    public let language: String
    public let people: [URL]
    public let films: [URL]
    public let created: Date
    public let edited: Date
    public let url: URL

    enum CodingKeys: String, CodingKey {
        case name, classification, designation
        case averageHeight = "average_height"
        case skinColors = "skin_colors"
        case hairColors = "hair_colors"
        case eyeColors = "eye_colors"
        case averageLifespan = "average_lifespan"
        case homeworld, language, people, films, created, edited, url
    }
}
