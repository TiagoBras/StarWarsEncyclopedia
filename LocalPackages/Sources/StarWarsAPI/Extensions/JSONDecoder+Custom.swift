import Foundation

extension JSONDecoder {
    /// JSON decoder used to decode responses from `https://swapi.dev/api`.
    static let starWars: JSONDecoder = {
        // Some dates have this format
        let iso8601 = ISO8601DateFormatter()
        iso8601.formatOptions = [.withInternetDateTime]
        
        // Most dates have this format
        let iso8601Fractional = ISO8601DateFormatter()
        iso8601Fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = iso8601Fractional.date(from: dateString) {
                return date
            } else if let date = iso8601.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unexpected date format: \(dateString)"
                    )
                )
            }
        })
        
        return decoder
    }()
}
