import UIKit

class EventsViewController: UIViewController {

    let tagline = UILabel()
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "EventsViewController"

        view.backgroundColor = .systemBackground
        
        name.accessibilityIdentifier = "NameLabel"
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label
        
        subtitle.accessibilityIdentifier = "SubtitleLabel"
        subtitle.font = UIFont.preferredFont(forTextStyle: .title2)
        subtitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [tagline, name, subtitle, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 250),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: subtitle)

        name.text = "The Name"
        subtitle.text = "The Subtitle"
    }
}
