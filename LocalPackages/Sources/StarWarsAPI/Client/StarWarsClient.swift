import Foundation

public struct StarWarsClient {
    public var getPeople: (_ page: Int) async throws -> PeopleResponse
}
