import Foundation

public struct PaginatedResponse<Model: StarWarsModel>: Decodable, Sendable {
    public var count: Int
    public var next: URL?
    public var previous: URL?
    public var results: [Model]
}

public extension PaginatedResponse {
    var nextPage: Int? {
        if let nextUrl = next,
           let components = URLComponents(url: nextUrl, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems,
           let pageString = queryItems.first(where: { $0.name == "page" })?.value,
           let page = Int(pageString), page >= 1
        {
            return page
        } else {
            return nil
        }
    }
}
