import Foundation

protocol SyncManager {
    var isSyncing: Bool { get }
    func startSync()
}

extension Notification.Name {
    static var syncSuccess: Notification.Name { return Notification.Name.init("SyncManager.syncSuccess") }
    static var syncFailure: Notification.Name { return Notification.Name.init("SyncManager.syncFailure") }
}
