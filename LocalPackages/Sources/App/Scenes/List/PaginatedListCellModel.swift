import UIKit
import StarWarsAPI

@MainActor
public struct CellSpecificationLayoutPriority: Sendable {
    public var priority: UILayoutPriority
    public var axis: NSLayoutConstraint.Axis
}

@MainActor
public struct CellSpecificationRowLabel: Sendable {
    public var font: UIFont = .preferredFont(forTextStyle: .body)
    public var color: UIColor = .swPrimaryText
    public var alignment: NSTextAlignment = .natural
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    public var hugging: CellSpecificationLayoutPriority? = nil
    public var compression: CellSpecificationLayoutPriority? = nil
    
    
    /// Creates a copy with `field` set with to `newValue`.
    public func update<T>(_ field: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var copy = self
        copy[keyPath: field] = newValue
        return copy
    }
}

@MainActor
public struct CellSpecificationRow: Sendable {
    public var columns: [CellSpecificationRowLabel]
    public var spacing: CGFloat = 0
    public var distribution: UIStackView.Distribution = .fill
}

@MainActor
public struct CellSpecification: Sendable {
    public var rows: [CellSpecificationRow]
    public var spacing: CGFloat = 0
    public var alignment: UIStackView.Alignment = .fill
}

@MainActor
public protocol PaginatedListCellModel {
    static func specification() -> CellSpecification
    
    /// Get text labels. The number of labels must match the number of Strings.
    func textLabels() -> [String?]
}

@MainActor
extension PaginatedListCellModel {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
