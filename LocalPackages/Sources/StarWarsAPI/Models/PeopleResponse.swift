import Foundation

public struct PeopleResponse: Codable {
    public let count: Int
    public let previous: URL?
    public let next: URL?
    public let results: [Person]
}

