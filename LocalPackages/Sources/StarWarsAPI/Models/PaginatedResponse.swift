import Foundation

public struct PaginatedResponse<Model: Decodable>: Decodable {
    public var count: Int
    public var next: URL?
    public var previous: URL?
    public var results: [Model]
}
