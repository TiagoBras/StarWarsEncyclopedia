import Foundation

import UIKit

class SpacingCell: UITableViewCell, Reusable {
    
    static let identifier = "SpacingCell"
    
    private var heightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        heightConstraint = view.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([
            heightConstraint,
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configure(height: CGFloat) {
        heightConstraint.constant = height
//        updateConstraintsIfNeeded()
//        layoutIfNeeded()
    }
}
