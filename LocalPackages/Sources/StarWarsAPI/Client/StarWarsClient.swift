import Foundation

public typealias PaginatedRequest<T: StarWarsModel> = @Sendable (_ page: Int) async throws -> PaginatedResponse<T>

public struct StarWarsClient: Sendable {
    public var getPeople: PaginatedRequest<Person>
    public var getPlanets: PaginatedRequest<Planet>
    public var getSpecies: PaginatedRequest<Species>
    public var getVehicles: PaginatedRequest<Vehicle>
    public var getStarships: PaginatedRequest<Starship>
    public var getFilms: PaginatedRequest<Film>
}
