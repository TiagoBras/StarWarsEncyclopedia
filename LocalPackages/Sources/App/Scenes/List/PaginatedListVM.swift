import Foundation
import Combine
import StarWarsAPI

final public class PaginatedListVM<Item: StarWarsModel>: @unchecked Sendable {
    public enum State: Equatable {
        case idle
        case loading
        case error(String)
    }
    
    // MARK: - Private Interface
    private let queue = DispatchQueue(label: "PaginatedVM-\(String(describing: Item.self))", attributes: .concurrent)
    private var _items = CurrentValueSubject<[Item], Never>([])
    private var _state = CurrentValueSubject<State, Never>(.idle)
    private var nextPage: Int? = 1
    private let fetchCallback: PaginatedRequest<Item>
    
    // MARK: - Public Interface
    public init(title: String, fetchCallback: @escaping PaginatedRequest<Item>) {
        self.title = title
        self.fetchCallback = fetchCallback
    }
    
    public let title: String
    
    public func numberOfItemsLoaded() -> Int {
        return queue.sync { _items.value.count }
    }
    
    public func hasLoadedAllItems() -> Bool {
        return queue.sync { nextPage == nil }
    }
    
    public func fetchItems() {
        queue.async(flags: .barrier) { [weak self] in
            guard let self, let page = nextPage, _state.value != .loading else {
                return
            }
            
            _state.send(.loading)
            
            Task { [weak self] in
                do {
                    guard let result = try await self?.fetchCallback(page) else { return }
                    
                    self?.queue.async(flags: .barrier) { [weak self] in
                        self?._items.value.append(contentsOf: result.results)
                        
                        if let nextPage = result.nextPage {
                            self?.nextPage = nextPage
                        } else {
                            self?.nextPage = nil
                        }
                        
                        self?._state.send(.idle)
                    }
                } catch {
                    self?.queue.async(flags: .barrier) { [weak self] in
                        // TODO: use unified logging
                        print("Fetch error: \(error)")
                        self?._state.send(.error(.tr.errors.fetchFailed))
                    }
                }
            }
        }
    }
    
    public typealias BindingClosure = (
        _ state: AnyPublisher<State, Never>,
        _ items: AnyPublisher<[Item], Never>
    ) -> Void
    
    public func bindFields(_ bindingClosure: BindingClosure) {
        // TODO: replace isLoading with an state enum
        queue.sync {
            let state = _state
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            let items = _items
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
            bindingClosure(state, items)
        }
    }
}
