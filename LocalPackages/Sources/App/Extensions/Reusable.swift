import UIKit

@MainActor
protocol Reusable {}

@MainActor
extension Reusable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell & Reusable>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell & Reusable>(_ cell: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
}
