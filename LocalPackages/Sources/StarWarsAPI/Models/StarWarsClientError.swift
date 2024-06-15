import Foundation

public struct StarWarsClientError: Error {
    public let status: Int
    public let detail: String
    
    public var localizedDescription: String {
        "Status: \(status), Details: \(detail)"
    }
}
