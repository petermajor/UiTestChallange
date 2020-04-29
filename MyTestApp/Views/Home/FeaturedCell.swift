import UIKit
import SDWebImage

class FeaturedCell: UICollectionViewCell {
    static let reuseIdentifier: String = "FeaturedCell"

    let tagline = UILabel()
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accessibilityIdentifier = "FeaturedCell"
        
        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel
        
        tagline.accessibilityIdentifier = "TaglineLabel"
        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemBlue
        
        name.accessibilityIdentifier = "NameLabel"
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label
        
        subtitle.accessibilityIdentifier = "SubtitleLabel"
        subtitle.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [separator, tagline, name, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: separator)
        stackView.setCustomSpacing(10, after: subtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with model: FeaturedCellModel) {
        tagline.text = model.tagline
        name.text = model.name
        subtitle.text = model.subtitle
        if let imageUrl = model.imageUrl {
            imageView.sd_setImage(with: imageUrl)
        }

        if model.isPlaceholder {
            let color = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
            tagline.textColor = .clear
            tagline.backgroundColor = color
            name.textColor = .clear
            name.backgroundColor = color
            subtitle.textColor = .clear
            subtitle.backgroundColor = color
            imageView.backgroundColor = color
        } else {
            tagline.textColor = .systemBlue
            tagline.backgroundColor = .clear
            name.textColor = .label
            name.backgroundColor = .clear
            subtitle.textColor = .secondaryLabel
            subtitle.backgroundColor = .clear
            imageView.backgroundColor = .clear
        }
    }

    override func prepareForReuse() {
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }
}
