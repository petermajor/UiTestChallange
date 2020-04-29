import UIKit

protocol Coordinator {
    func start() -> UIViewController
    func homeFeaturedItemTapped(for eventKey: ShowcaseEventKey)
}
