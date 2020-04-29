import UIKit

class HomeViewModel: NSObject {
    
    private let maxFeaturedCount = 8
    private let maxOnDemandCount = 15
    private let notificationCenter: NotificationCenter
    private let showcaseRepository: ShowcaseRepository
    private let configuration: Configuration
    private let coordinator: Coordinator

    private let dateFormatter: DateFormatter
  
    let title: String
    private(set) var sections: Observable<[SectionViewModel]>

    init(notificationCenter: NotificationCenter, showcaseRepository: ShowcaseRepository, configuration: Configuration, coordinator: Coordinator) {
        self.notificationCenter = notificationCenter
        self.showcaseRepository = showcaseRepository
        self.configuration = configuration
        self.coordinator = coordinator
        
        title = "Shows"
        
        sections = Observable([SectionViewModel]())
        
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        super.init()
        
        notificationCenter.addObserver(self, selector: #selector(onSyncSuccess), name: Notification.Name.syncSuccess, object: nil)
        reloadEventsInSections()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc private func onSyncSuccess(notification: Notification) {
        reloadEventsInSections()
    }
    
    private func reloadEventsInSections() {
        
        var result = [SectionViewModel]()
        
        let featured = createFeaturedSectionViewModel()
        if featured.events.count > 0 {
            result.append(featured)
        }
        
        let onDemand = createOnDemandSectionViewModel()
        if onDemand.events.count > 0 {
            result.append(onDemand)
        }
        
        sections.value = result
    }

    private func createFeaturedSectionViewModel() -> SectionViewModel {
        var events = showcaseRepository.getFeaturedKeys(maxLength: maxFeaturedCount)
        if events.count == 0 {
            events = [ShowcaseEventKey(svcId: -1, evtId: 0)]
        }
        
        let section = SectionViewModel(
            type: .featured,
            title: "",    // not shown on featured group
            subtitle: "", // not shown on featured group
            events: events)
        return section
    }
    
    private func createOnDemandSectionViewModel() -> SectionViewModel {
        var events = showcaseRepository.getOnDemandKeys(maxLength: maxOnDemandCount)
        if events.count == 0 {
            events = [ShowcaseEventKey(svcId: -2, evtId: 0), ShowcaseEventKey(svcId: -2, evtId: 1), ShowcaseEventKey(svcId: -2, evtId: 2), ShowcaseEventKey(svcId: -2, evtId: 3), ShowcaseEventKey(svcId: -2, evtId: 4)]
        }

        let section = SectionViewModel(
            type: .onDemand,
            title: "On Demand",
            subtitle: "Watch these shows now",
            events: events)
        return section
    }

    func getFeaturedCellModel(for eventKey: ShowcaseEventKey) -> FeaturedCellModel? {
        guard let event = showcaseRepository.get(by: eventKey) else {
            return FeaturedCellModel(tagline: "Placeholder", name: "Placeholder", subtitle: "Placeholder", imageUrl: nil, isPlaceholder: true)
        }
        
        let viewmodel = FeaturedCellModel(
            tagline: "Featured".uppercased(),
            name: event.sc_title,
            subtitle: dateFormatter.string(from: event.startTime),
            imageUrl: configuration.baseImageUrl.appendingPathComponent(event.sc_image),
            isPlaceholder: false)
        return viewmodel
    }
    
    func getOnDemandCellModel(for eventKey: ShowcaseEventKey) -> OnDemandCellModel? {
        guard let event = showcaseRepository.get(by: eventKey) else {
            return OnDemandCellModel(name: "Placeholder", subtitle: "Placeholder", imageUrl: nil, isPlaceholder: true)
        }

        let viewmodel = OnDemandCellModel(
            name: event.sc_title,
            subtitle: dateFormatter.string(from: event.startTime),
            imageUrl: configuration.baseImageUrl.appendingPathComponent(event.sc_image),
            isPlaceholder: false)
        return viewmodel
    }
    
    func itemTapped(for indexPath: IndexPath) {
        guard let sections = sections.value else { return }
        let section = sections[indexPath.section]
        let eventKey = section.events[indexPath.row]
        
        switch section.type {
        default:
            coordinator.homeFeaturedItemTapped(for: eventKey)
        }
    }
}
