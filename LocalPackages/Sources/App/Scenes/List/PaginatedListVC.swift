import UIKit
import StarWarsAPI
import Combine

class PaginatedListVC<Model: PaginatedListCellModel & StarWarsModel>: UIViewController, UITableViewDelegate {
    public typealias OnDidSelectItem = (UIViewController, Model) -> Void
    
    // MARK: - Internal Models
    enum State {
        case valid
        case error(String)
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Private properties
    private let viewModel: PaginatedListVM<Model>
    private let onDidSelectItem: OnDidSelectItem?
    private var maxDisplayedCellRow = 0
    private var dataSource: UITableViewDiffableDataSource<Section, Model>!
    private var subscriptions = Set<AnyCancellable>()
    private var state: State = .valid {
        didSet {
            onStateChange(state)
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PaginatedListCell<Model>.self, forCellReuseIdentifier: PaginatedListCell<Model>.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 78
        tableView.tableFooterView = loadingIndicator
        tableView.delegate = self
        return tableView
    }()
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = .gray
        activity.hidesWhenStopped = true
        activity.frame = CGRect(origin: .zero, size: .init(width: 60, height: 60))
        return activity
    }()
    private lazy var errorView: ErrorView = {
        let errorView = ErrorView { [weak self] in
            self?.onRetryButtonTap()
        }
        errorView.backgroundColor = .swBackground
        errorView.isHidden = true
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()
    
    // MARK: - View Lifecycle
    init(viewModel: PaginatedListVM<Model>, onDidSelectItem: OnDidSelectItem? = nil) {
        self.viewModel = viewModel
        self.onDidSelectItem = onDidSelectItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        view.addSubview(tableView)
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            errorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        setupDataSource()
        setupViewModel()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath) else { return }
        
        onDidSelectItem?(self, model)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Simple logic to fetch more rows when it's reaching the end of current data source
        guard indexPath.row > maxDisplayedCellRow else { return }
        
        maxDisplayedCellRow = indexPath.row
        
        guard
            !viewModel.hasLoadedAllItems(),
            indexPath.row + 2 >= viewModel.numberOfItemsLoaded()
        else {
            return
        }
        
        viewModel.fetchItems()
    }
        
    // MARK: - Private interface
    private func setupViewModel() {
        viewModel.bindFields { state, items in
            state
                .sink { state in
                    switch state {
                    case .idle:
                        self.state = .valid
                        self.loadingIndicator.stopAnimating()
                    case .loading:
                        self.state = .valid
                        self.loadingIndicator.startAnimating()
                    case .error(let message):
                        self.state = .error(message)
                        self.loadingIndicator.stopAnimating()
                    }
                }
                .store(in: &subscriptions)
            
            items
                .sink { [weak dataSource] films in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(films, toSection: .main)
                    
                    guard let dataSource else {
                        assertionFailure("DataSource should NOT be nil by now")
                        return
                    }

                    dataSource.apply(snapshot, animatingDifferences: false)
                }
                .store(in: &subscriptions)
        }
        
        if !viewModel.hasLoadedAllItems() {
            viewModel.fetchItems()
        }
    }
    
    private func setupDataSource() {
        let accessoryType: UITableViewCell.AccessoryType = onDidSelectItem != nil ? .disclosureIndicator : .none
        
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PaginatedListCell<Model>.identifier,
                for: indexPath) as! PaginatedListCell<Model>
            cell.updateCell(item)
            cell.accessoryType = accessoryType
            return cell
        })
    }
    
    private func onStateChange(_ newState: State) {
        switch newState {
        case .valid:
            tableView.isHidden = false
            errorView.isHidden = true
        case .error(let string):
            errorView.updateErrorMessage(string)
            tableView.isHidden = true
            errorView.isHidden = false
        }
    }
    
    private func onRetryButtonTap() {
        viewModel.fetchItems()
    }
}
