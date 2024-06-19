import UIKit

class TitleCell: UITableViewCell, Reusable {
    
    static let identifier = "TitleCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .swPrimaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        let verticalMargin: CGFloat = 8
        let horizontalMargin: CGFloat = 16
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: verticalMargin),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -verticalMargin),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: horizontalMargin),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -horizontalMargin),
        ])
    }
    
    // MARK: - Public Interface
    func configure(title: String?, alignment: NSTextAlignment) {
        titleLabel.text = title
        titleLabel.textAlignment = alignment
    }
}
