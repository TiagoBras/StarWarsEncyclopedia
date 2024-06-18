import UIKit
import StarWarsAPI
import Combine

struct PaginatedListItem<Model: StarWarsModel>: Hashable {
    var id: Int
    var model: Model
}

class PaginatedListVC<Model: PaginatedListCellModel & StarWarsModel>: UIViewController, UITableViewDelegate {
    public typealias OnDidSelectItem = (UIViewController, Model) -> Void
    
    // MARK: - Internal Models
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Private properties
    private let viewModel: PaginatedListVM<Model>
    private let onDidSelectItem: OnDidSelectItem?
    private var maxDisplayedCellRow = 0
    private var dataSource: UITableViewDiffableDataSource<Section, PaginatedListItem<Model>>!
    private var subscriptions = Set<AnyCancellable>()
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        setupDataSource()
        setupViewModel()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = dataSource.itemIdentifier(for: indexPath)?.model else { return }
        
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
        viewModel.bindFields { items, isLoading, errorMessage in
            items
                .map { films in films.enumerated() }
                .map { enumeratedFilms in enumeratedFilms.map { PaginatedListItem(id: $0.offset, model: $0.element) }}
                .sink { [weak dataSource, maxDisplayedCellRow] films in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, PaginatedListItem<Model>>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(films, toSection: .main)
                    
                    guard let dataSource else {
                        assertionFailure("DataSource should NOT be nil by now")
                        return
                    }
                    
                    // Don't animate during the first load
                    dataSource.apply(snapshot, animatingDifferences: maxDisplayedCellRow > 0)
                }
                .store(in: &subscriptions)
            
            isLoading.sink { [weak loadingIndicator] isLoading in
                if isLoading {
                    loadingIndicator?.startAnimating()
                } else {
                    loadingIndicator?.stopAnimating()
                }
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
            cell.updateCell(item.model)
            cell.accessoryType = accessoryType
            return cell
        })
    }
}
