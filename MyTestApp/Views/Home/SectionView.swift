import UIKit

class SectionView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    let title = UILabel()
    let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let separator = UIView(frame: CGRect.zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel
        
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        title.textColor = .label
        
        subtitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        subtitle.textColor = .secondaryLabel
        
        let stackView = UIStackView(arrangedSubviews: [separator, title, subtitle])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(10, after: separator)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with model: SectionViewModel) {
        title.text = model.title
        subtitle.text = model.subtitle
    }
}
