import Foundation

protocol ShowcaseRepository {
    func set(data: ShowcaseResponse)
    func getFeaturedKeys(maxLength: Int) -> [ShowcaseEventKey]
    func getOnDemandKeys(maxLength: Int) -> [ShowcaseEventKey]
    func get(by key: ShowcaseEventKey) -> ShowcaseEvent?
}
