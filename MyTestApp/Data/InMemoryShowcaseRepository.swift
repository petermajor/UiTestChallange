import Foundation

// this would normally read and write to a database
// for demo purposes this just keeps the data in memory though

class InMemoryShowcaseRepository: ShowcaseRepository {

    private let featuredPageTitle = "on tv"
    private let onDemandPageTitle = "on demand"
    
    private var featured: ShowcaseFilter?
    private var onDemand: ShowcaseFilter?
    private var events = [ShowcaseEventKey: ShowcaseEvent]()
    
    func set(data: ShowcaseResponse) {
        self.featured = getFilter(from: data, with: featuredPageTitle)
        self.onDemand = getFilter(from: data, with: onDemandPageTitle)
        self.events = getEvents(from: data)
    }
    
    private func getFilter(from data: ShowcaseResponse, with title: String) -> ShowcaseFilter? {
        let page = data.pages.first(where: { $0.title == title })
        let filter = page?.filters.first(where: { $0.id == page!.startfilter })
        return filter
    }
    
    private func getEvents(from data: ShowcaseResponse) -> [ShowcaseEventKey: ShowcaseEvent] {
        return Dictionary<ShowcaseEventKey, ShowcaseEvent>(uniqueKeysWithValues: data.showcase_events.map({ ($0.key, $0)}))
    }
    
    func getFeaturedKeys(maxLength: Int) -> [ShowcaseEventKey] {
        return featured?.events.prefix(maxLength).map { $0.key } ?? [ShowcaseEventKey]()
    }

    func getOnDemandKeys(maxLength: Int) -> [ShowcaseEventKey] {
        return onDemand?.events.prefix(maxLength).map { $0.key } ?? [ShowcaseEventKey]()
    }
    
    func get(by key: ShowcaseEventKey) -> ShowcaseEvent? {
        return events[key]
    }
}
