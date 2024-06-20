import XCTest
import App
import StarWarsAPI
import Combine

class PaginatesListVMTests: XCTestCase {
    private let client = StarWarsClient.test
    
    func testPaginatedViewModel() async throws {
        try await assertViewModel(client.getFilms)
        try await assertViewModel(client.getPeople)
        try await assertViewModel(client.getPlanets)
        try await assertViewModel(client.getSpecies)
        try await assertViewModel(client.getStarships)
        try await assertViewModel(client.getVehicles)
    }
    
    private func assertViewModel<T: StarWarsModel>(_ callback: @escaping PaginatedRequest<T>) async throws {
        let itemsExpectation = expectation(description: "\(#function).items")
        let stateExpectation = expectation(description: "\(#function).state")
        let title = UUID().uuidString
        let vm = PaginatedListVM(title: title, fetchCallback: callback)
        var rowsFetchedHistory: [Int] = []
        var stateHistory: [PaginatedListVM<T>.State] = []
        var subs = Set<AnyCancellable>()
        
        XCTAssertEqual(vm.title, title)
        XCTAssertEqual(vm.hasLoadedAllItems(), false)
        XCTAssertEqual(vm.numberOfItemsLoaded(), 0)
        
        // Store history of values so that we can compare it later and see if it's behaving as expected
        vm.bindFields { state, items in
            items.sink { people in
                rowsFetchedHistory.append(people.count)
                
                if vm.hasLoadedAllItems() {
                    itemsExpectation.fulfill()
                } else {
                    vm.fetchItems()
                }
            }
            .store(in: &subs)
            
            state.sink { state in
                stateHistory.append(state)
                
                if vm.hasLoadedAllItems() {
                    stateExpectation.fulfill()
                }
            }
            .store(in: &subs)
        }
        
        vm.fetchItems()
        
        await fulfillment(of: [itemsExpectation, stateExpectation], timeout: 5)
        
        let expectedItemsHistory = try await expectedFetchedRowsHistory(callback)
        XCTAssertEqual(rowsFetchedHistory, expectedItemsHistory)
        
        // States should go .idle, .loading, .idle, .loading, .idle, ...
        for (i, state) in stateHistory.enumerated() {
            if i.isMultiple(of: 2) {
                XCTAssertEqual(state, .idle)
            } else {
                XCTAssertEqual(state, .loading)
            }
        }
    }
    
    private func expectedFetchedRowsHistory<T: StarWarsModel>(_ callback: PaginatedRequest<T>) async throws -> [Int] {
        var nextPage: Int? = 1
        var rowsFetched = [0]
        
        while true {
            guard let page = nextPage else { break }
            
            let result = try await callback(page)
            rowsFetched.append(rowsFetched.last! + result.results.count)
            nextPage = result.nextPage
        }
        
        return rowsFetched
    }
}
