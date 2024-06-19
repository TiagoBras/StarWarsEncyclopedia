import UIKit

@MainActor
final class ErrorView: UIView {
    typealias OnTap = () -> Void
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .swSecondaryText
        label.text = "- Error Message -"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.tr.common.retry, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        return button
    }()
    
    var onTap: OnTap? = nil
    
    init(onTap: OnTap? = nil) {
        self.onTap = onTap
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let horizontalMargin: CGFloat = 16
        let stackView = UIStackView(arrangedSubviews: [errorMessageLabel, retryButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: horizontalMargin),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -horizontalMargin),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
        ])
        
        retryButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc private func handleTap() {
        onTap?()
    }
    
    func updateErrorMessage(_ message: String?) {
        errorMessageLabel.text = message
    }
}
