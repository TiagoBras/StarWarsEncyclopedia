import Foundation

public struct Starship: Codable {
    public let name: String
    public let model: String
    public let manufacturer: String
    public let costInCredits: String
    public let length: String
    public let maxAtmospheringSpeed: String
    public let crew: String
    public let passengers: String
    public let cargoCapacity: String
    public let consumables: String
    public let hyperdriveRating: String
    public let mglt: String
    public let starshipClass: String
    public let pilots: [URL]
    public let films: [URL]
    public let created: Date
    public let edited: Date
    public let url: URL

    enum CodingKeys: String, CodingKey {
        case name, model, manufacturer
        case costInCredits = "cost_in_credits"
        case length
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case crew, passengers
        case cargoCapacity = "cargo_capacity"
        case consumables
        case hyperdriveRating = "hyperdrive_rating"
        case mglt = "MGLT"
        case starshipClass = "starship_class"
        case pilots, films, created, edited, url
    }
}
