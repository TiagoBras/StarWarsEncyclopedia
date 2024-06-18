import Foundation
import Combine
import StarWarsAPI

final public class PaginatedListVM<Item: StarWarsModel>: @unchecked Sendable {
    // MARK: - Private Interface
    private let queue = DispatchQueue(label: "PaginatedVM-\(String(describing: Item.self))", attributes: .concurrent)
    private var _items = CurrentValueSubject<[Item], Never>([])
    private var _isLoading = CurrentValueSubject<Bool, Never>(false)
    private var _errorMessage = CurrentValueSubject<String?, Never>(nil)
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
            guard let self, let page = nextPage, !_isLoading.value else {
                return
            }
            
            _isLoading.send(true)
            
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
                        
                        self?._isLoading.send(false)
                    }
                } catch {
                    self?.queue.async(flags: .barrier) { [weak self] in
                        self?._errorMessage.send("Could not fetch items.")
                        self?._isLoading.send(true)
                    }
                }
            }
        }
    }
    
    public typealias BindingClosure = (
        _ items: AnyPublisher<[Item], Never>,
        _ isLoading: AnyPublisher<Bool, Never>,
        _ errorMessage: AnyPublisher<String?, Never>
    ) -> Void
    
    public func bindFields(_ bindingClosure: BindingClosure) {
        queue.sync {
            let items = _items
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            let isLoading = _isLoading
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            let errorMessage = _errorMessage
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            
            bindingClosure(items, isLoading, errorMessage)
        }
    }
}
