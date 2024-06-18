import UIKit
import StarWarsAPI
import Combine

struct PaginatedListItem<Model: StarWarsModel>: Hashable {
    var id: Int
    var model: Model
}

class PaginatedListVC<Model: PaginatedListCellModel & StarWarsModel>: UIViewController, UITableViewDelegate {
    
    // MARK: - Internal Models
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Private properties
    private let viewModel: PaginatedListVM<Model>
    private var maxDisplayedCellRow = 0
    private var dataSource: UITableViewDiffableDataSource<Section, PaginatedListItem<Model>>!
    private var subscriptions = Set<AnyCancellable>()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PaginatedListCell<Model>.self, forCellReuseIdentifier: PaginatedListCell<Model>.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - View Lifecycle
    init(viewModel: PaginatedListVM<Model>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        setupViewModel()
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(#function): \(indexPath)")
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
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: PaginatedListCell<Model>.identifier,
                for: indexPath) as! PaginatedListCell<Model>
            cell.updateCell(item.model)
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        
        viewModel.bindFields { items, isLoading, errorMessage in
            items
                .map { films in films.enumerated() }
                .map { enumeratedFilms in enumeratedFilms.map { PaginatedListItem(id: $0.offset, model: $0.element) }}
                .sink { [weak dataSource] films in
                    var snapshot = NSDiffableDataSourceSnapshot<Section, PaginatedListItem<Model>>()
                    snapshot.appendSections([.main])
                    snapshot.appendItems(films, toSection: .main)
                    
                    dataSource?.apply(snapshot, animatingDifferences: true)
                }
                .store(in: &subscriptions)
        }
        
        if !viewModel.hasLoadedAllItems() {
            viewModel.fetchItems()
        }
        
        title = viewModel.title
    }
}
