import UIKit

class SeparatorCell: UITableViewCell, Reusable {
    
    static let identifier = "SeparatorCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let horizontalMargin: CGFloat = 16
        let verticalMargin: CGFloat = 8
        let separatorView = UIView()
        separatorView.backgroundColor = .swSeparator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalMargin),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalMargin),
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
        ])
    }
}
