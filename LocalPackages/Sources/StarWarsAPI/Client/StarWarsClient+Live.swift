import Foundation

extension StarWarsClient {
    private static let baseUrl = URL(string: "https://swapi.dev/api/")!
    private static func fetch<T: StarWarsModel>(path: String, page: Int) async throws -> PaginatedResponse<T> {
        let url = baseUrl.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [URLQueryItem(name: "page", value: String(page))]
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        
        return try JSONDecoder.starWars.decode(PaginatedResponse<T>.self, from: data)
    }
    
    public static let live = Self { page in
        try await fetch(path: "people", page: page)
    } getPlanets: { page in
        try await fetch(path: "films", page: page)
    } getSpecies: { page in
        try await fetch(path: "species", page: page)
    } getVehicles: { page in
        try await fetch(path: "vehicles", page: page)
    } getStarships: { page in
        try await fetch(path: "starships", page: page)
    } getFilms: { page in
        try await fetch(path: "films", page: page)
    }

}
