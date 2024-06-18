import UIKit

class TitleDetailsCell: UITableViewCell, Reusable {
    
    static let identifier = "TitleDetailsCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .swPrimaryText
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .swSecondaryText
        label.textAlignment = .right
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
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
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
    }
    
    func configure(title: String?, details: String?) {
        titleLabel.text = title
        detailsLabel.text = details
    }
}
