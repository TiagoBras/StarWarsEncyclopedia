import Foundation

extension JSONDecoder {
    /// JSON decoder used to decode responses from `https://swapi.dev/api`.
    static let starWars: JSONDecoder = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = dateFormatter.date(from: dateString) {
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
