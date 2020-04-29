import Foundation

protocol ShowcaseQuery {
    func execute(completion: @escaping (ShowcaseResponse?) -> Void)
}
