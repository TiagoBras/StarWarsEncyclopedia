import Foundation

public struct PaginatedResponse<Model: StarWarsModel>: Decodable, Sendable {
    public var count: Int
    public var next: URL?
    public var previous: URL?
    public var results: [Model]
}
