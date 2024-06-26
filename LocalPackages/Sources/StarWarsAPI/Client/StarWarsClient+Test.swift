import Foundation

extension StarWarsClient {
    public static let test = StarWarsClient { page in
        try responseFromFile("people?page=\(page)", PaginatedResponse<Person>.self)
    } getPlanets: { page in
        try responseFromFile("planets?page=\(page)", PaginatedResponse<Planet>.self)
    } getSpecies: { page in
        try responseFromFile("species?page=\(page)", PaginatedResponse<Species>.self)
    } getVehicles: { page in
        try responseFromFile("vehicles?page=\(page)", PaginatedResponse<Vehicle>.self)
    } getStarships: { page in
        try responseFromFile("starships?page=\(page)", PaginatedResponse<Starship>.self)
    } getFilms: { page in
        try responseFromFile("films?page=\(page)", PaginatedResponse<Film>.self)
    }
    
    /// Loads JSON response from local file and decodes it into `model`.
    /// - Parameters:
    ///   - filename: Response's JSON filename.
    ///   - model: Response's model.
    /// - Returns: Decoded response or `ClientError` if no file was found.
    static func responseFromFile<T: Decodable>(_ filename: String, _ model: T.Type) throws -> T {
        guard let url = Bundle.module.url(
            forResource: filename,
            withExtension: "json",
            subdirectory: "FakeResponses")
        else {
            throw StarWarsClientError(status: 404, detail: "Not found")
        }
        
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder.starWars.decode(model, from: data)
    }
}
