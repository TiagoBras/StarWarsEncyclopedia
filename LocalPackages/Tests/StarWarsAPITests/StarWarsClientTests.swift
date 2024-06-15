import XCTest
import StarWarsAPI

class StarWarsClientTests: XCTestCase {
    func testGetPeopleMultipleTimes() async throws {
        let response1 = try await StarWarsClient.test.getPeople(1)
        
        XCTAssertEqual(response1.count, 19)
        XCTAssertEqual(response1.next, URL(string: "https://swapi.dev/api/people/?page=2"))
        XCTAssertNil(response1.previous)
        XCTAssertEqual(response1.results.count, 10)
        
        let person = response1.results[0]
        XCTAssertEqual(person.name, "Luke Skywalker")
        XCTAssertEqual(person.created, Date(timeIntervalSince1970: 1_418_133_051.644))
        
        let response2 = try await StarWarsClient.test.getPeople(2)
        XCTAssertEqual(response2.count, 19)
        XCTAssertNil(response2.next)
        XCTAssertEqual(response2.previous, URL(string: "https://swapi.dev/api/people/?page=1"))
        
        do {
            _ = try await StarWarsClient.test.getPeople(3)
            XCTFail("Above call should throw an error")
        } catch let error as StarWarsClientError {
            XCTAssertEqual(error.status, 404)
            XCTAssertEqual(error.detail, "Not found")
        }
    }
    
    func testGetPlanetsMultipleTimes() async throws {
        let response1 = try await StarWarsClient.test.getPlanets(2)
        XCTAssertEqual(response1.count, 18)
        XCTAssertNil(response1.next)
        XCTAssertEqual(response1.previous, URL(string: "https://swapi.dev/api/planets/?page=1"))
        XCTAssertEqual(response1.results.count, 8)
        
        do {
            _ = try await StarWarsClient.test.getPlanets(3)
            XCTFail("Above call should throw an error")
        } catch let error as StarWarsClientError {
            XCTAssertEqual(error.status, 404)
            XCTAssertEqual(error.detail, "Not found")
        }
    }
    
    func testGetSpeciesMultipleTimes() async throws {
        let response1 = try await StarWarsClient.test.getSpecies(2)
        XCTAssertEqual(response1.count, 12)
        XCTAssertNil(response1.next)
        XCTAssertEqual(response1.previous, URL(string: "https://swapi.dev/api/species/?page=1"))
        XCTAssertEqual(response1.results.count, 2)
        
        do {
            _ = try await StarWarsClient.test.getSpecies(3)
            XCTFail("Above call should throw an error")
        } catch let error as StarWarsClientError {
            XCTAssertEqual(error.status, 404)
            XCTAssertEqual(error.detail, "Not found")
        }
    }
    
    func testGetVehiclesMultipleTimes() async throws {
        let response1 = try await StarWarsClient.test.getVehicles(2)
        XCTAssertEqual(response1.count, 11)
        XCTAssertNil(response1.next)
        XCTAssertEqual(response1.previous, URL(string: "https://swapi.dev/api/vehicles/?page=1"))
        XCTAssertEqual(response1.results.count, 1)
        
        do {
            _ = try await StarWarsClient.test.getVehicles(3)
            XCTFail("Above call should throw an error")
        } catch let error as StarWarsClientError {
            XCTAssertEqual(error.status, 404)
            XCTAssertEqual(error.detail, "Not found")
        }
    }
}
