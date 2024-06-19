import UIKit

class DetailsVC: UIViewController {
    // MARK: - Internal Models
    enum Section: CaseIterable {
        case main
    }
    
    struct Item: Hashable {
        var id: Int
        var model: DetailsModelCell
    }
    
    private var viewModel: DetailsVM!
    private var dataSource: UITableViewDiffableDataSource<Section, Item>!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerCell(TitleCell.self)
        tableView.registerCell(TitleDetailsCell.self)
        tableView.registerCell(SeparatorCell.self)
        tableView.registerCell(SpacingCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    init(viewModel: DetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        title = viewModel.model.modelTitle
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item.model {
            case let .title(title, alignment):
                let cell = tableView.dequeueReusableCell(TitleCell.self, indexPath: indexPath)
                cell.configure(title: title, alignment: alignment)
                cell.isUserInteractionEnabled = false
                return cell
                
            case let .titleDetails(title, details):
                let cell = tableView.dequeueReusableCell(TitleDetailsCell.self, indexPath: indexPath)
                cell.configure(title: title, details: details)
                cell.isUserInteractionEnabled = false
                return cell
                
            case .separator:
                let cell = tableView.dequeueReusableCell(SeparatorCell.self, indexPath: indexPath)
                cell.isUserInteractionEnabled = false
                return cell
                
            case let .spacing(height):
                let cell = tableView.dequeueReusableCell(SpacingCell.self, indexPath: indexPath)
                cell.configure(height: height)
                cell.isUserInteractionEnabled = false
                return cell
            }
        })
        
        let items = viewModel.model.modelCells.enumerated().map { offset, model in
            Item(id: offset, model: model)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
