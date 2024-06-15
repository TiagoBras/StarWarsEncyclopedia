import Foundation

public struct StarWarsClient {
    public var getPeople: (_ page: Int) async throws -> PaginatedResponse<Person>
    public var getPlanets: (_ page: Int) async throws -> PaginatedResponse<Planet>
}
