import Foundation

public struct Person: StarWarsModel {
    public let name: String
    public let height: String
    public let mass: String
    public let hairColor: String
    public let skinColor: String
    public let eyeColor: String
    public let birthYear: String
    public let gender: String
    public let homeworld: URL
    public let films: [URL]
    public let species: [URL]
    public let vehicles: [URL]
    public let starships: [URL]
    public let created: Date
    public let edited: Date
    public let url: URL

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}
