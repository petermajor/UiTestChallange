import UIKit

class OnDemandCell: UICollectionViewCell {
    static var reuseIdentifier: String = "MediumTableCell"
    
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let innerStackView = UIStackView(arrangedSubviews: [name, subtitle])
        innerStackView.axis = .vertical
        
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.axis = .horizontal
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.77),
            contentView.leadingAnchor.constraint(equalTo: outerStackView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: outerStackView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: outerStackView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: outerStackView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with model: OnDemandCellModel) {
        name.text = model.name
        subtitle.text = model.subtitle
        if let imageUrl = model.imageUrl {
            imageView.sd_setImage(with: imageUrl)
        }
        
        if model.isPlaceholder {
            let color = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
            name.textColor = .clear
            name.backgroundColor = color
            subtitle.textColor = .clear
            subtitle.backgroundColor = color
            imageView.backgroundColor = color
        } else {
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
