import UIKit
import Combine
import DesignSystem
import StarWarsAPI

@MainActor
public final class PaginatedListCell<Model: PaginatedListCellModel>: UITableViewCell {
    public static var identifier: String { Model.reuseIdentifier }
    private var numberOfLabels = 0
    private var stackView: UIStackView!
    
    // MARK: - View life cycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let verticalMargin: CGFloat = 8
        let horizontalMargin: CGFloat = 16
        let spec = Model.specification()
        
        // Build horizontal stackviews of labels
        let rows: [UIStackView] = spec.rows.map { row in
            let labels: [UILabel] = row.columns.map { column in
                let label = UILabel()
                label.font = column.font
                label.textColor = column.color
                label.textAlignment = column.alignment
                label.lineBreakMode = column.lineBreakMode
                label.translatesAutoresizingMaskIntoConstraints = false
                
                if let hugging = column.hugging {
                    label.setContentHuggingPriority(hugging.priority, for: hugging.axis)
                }
                
                if let compression = column.compression {
                    label.setContentCompressionResistancePriority(compression.priority, for: compression.axis)
                }
                
                return label
            }
            
            let stackView = UIStackView(arrangedSubviews: labels)
            stackView.distribution = row.distribution
            stackView.spacing = row.spacing
            stackView.axis = .horizontal
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            return stackView
        }
        
        stackView = UIStackView(arrangedSubviews: rows)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = spec.spacing
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: verticalMargin),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -verticalMargin),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: horizontalMargin),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -horizontalMargin),
        ])
        
        numberOfLabels = rows.reduce(0, { $0 + $1.arrangedSubviews.count })
    }
    
    public func updateCell(_ cell: Model) {
        let textLabels = cell.textLabels()
        
        assert(
            textLabels.count == numberOfLabels,
            "\(textLabels.count) doesn't match \(numberOfLabels)"
        )
        
        // Updates all labels inside the stackviews
        let labels = stackView.arrangedSubviews
            .compactMap({ $0 as? UIStackView })
            .flatMap({ $0.arrangedSubviews as! [UILabel] })
        
        
        zip(labels, textLabels).forEach { (label, text) in
            label.text = text
        }
    }
    
    private func getMultiArrayShape<T>(_ array: Array<Array<T>>) -> [Int] {
        return array.map(\.count)
    }
}


