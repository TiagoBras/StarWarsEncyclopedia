import Foundation

public struct StarWarsClient {
    public var getPeople: (_ page: Int) async throws -> PaginatedResponse<Person>
    public var getPlanets: (_ page: Int) async throws -> PaginatedResponse<Planet>
    public var getSpecies: (_ page: Int) async throws -> PaginatedResponse<Species>
    public var getVehicles: (_ page: Int) async throws -> PaginatedResponse<Vehicle>
    public var getStarships: (_ page: Int) async throws -> PaginatedResponse<Starship>
    public var getFilms: (_ page: Int) async throws -> PaginatedResponse<Film>
}
