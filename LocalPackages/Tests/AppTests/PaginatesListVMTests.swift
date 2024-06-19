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
        let isLoadingExpectation = expectation(description: "\(#function).isLoading")
        let errorExpectation = expectation(description: "\(#function).error")
        let title = UUID().uuidString
        let vm = PaginatedListVM(title: title, fetchCallback: callback)
        var rowsFetchedHistory: [Int] = []
        var isLoadingHistory: [Bool] = []
        var subs = Set<AnyCancellable>()
        
        XCTAssertEqual(vm.title, title)
        XCTAssertEqual(vm.hasLoadedAllItems(), false)
        XCTAssertEqual(vm.numberOfItemsLoaded(), 0)
        
        // Store history of values so that we can compare it later and see if it's behaving as expected
        vm.bindFields { items, isLoading, errorMessage in
            items.sink { people in
                rowsFetchedHistory.append(people.count)
                
                if vm.hasLoadedAllItems() {
                    itemsExpectation.fulfill()
                } else {
                    vm.fetchItems()
                }
            }
            .store(in: &subs)
            
            isLoading.sink { isLoading in
                isLoadingHistory.append(isLoading)
                
                if vm.hasLoadedAllItems() && !isLoading {
                    isLoadingExpectation.fulfill()
                }
            }
            .store(in: &subs)
            
            errorMessage.sink { errorMessage in
                XCTAssertNil(errorMessage)
                errorExpectation.fulfill()
            }
            .store(in: &subs)
        }
        
        vm.fetchItems()
        
        await fulfillment(of: [itemsExpectation, isLoadingExpectation, errorExpectation], timeout: 5)
        
        let expectedItemsHistory = try await expectedFetchedRowsHistory(callback)
        XCTAssertEqual(rowsFetchedHistory, expectedItemsHistory)
        
        let expectedIsLoadingHistory = Array(repeating: [false, true], count: expectedItemsHistory.count - 1).flatMap({$0}) + [false]
        XCTAssertEqual(isLoadingHistory, expectedIsLoadingHistory)
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
