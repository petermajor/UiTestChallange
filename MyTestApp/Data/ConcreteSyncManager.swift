import Foundation

class ConcreteSyncManager: SyncManager {

    private(set) var isSyncing: Bool = false
    private let showcaseRepository: ShowcaseRepository
    private let showcaseQuery: ShowcaseQuery
    
    init(showcaseRepository: ShowcaseRepository, showcaseQuery: ShowcaseQuery) {
        self.showcaseRepository = showcaseRepository
        self.showcaseQuery = showcaseQuery
    }
    
    func startSync() {
        
        guard !isSyncing else { return }
        
        isSyncing = true
        
        showcaseQuery.execute{ [weak self] response in
            guard let response = response else {
                self?.syncComplete(Notification.Name.syncFailure)
                return
            }
            
            self?.showcaseRepository.set(data: response)
            
            self?.syncComplete(Notification.Name.syncSuccess)
        }
    }
    
    private func syncComplete(_ name: Notification.Name) {
        isSyncing = false
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
}
