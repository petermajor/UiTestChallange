import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {

        // singleton
        register { MainCoordinator() as Coordinator }.scope(application)
        register { ConcreteSyncManager(showcaseRepository: resolve(), showcaseQuery: resolve()) as SyncManager }.scope(application)
        register { InMemoryShowcaseRepository() as ShowcaseRepository }.scope(application)
        register { Configuration() }.scope(application)

        // unique
        register { FreesatShowcaseQuery(configuration: resolve()) as ShowcaseQuery }.scope( unique )
        register { HomeViewModel(notificationCenter: NotificationCenter.default, showcaseRepository: resolve(), configuration: resolve(), coordinator: resolve()) }.scope( unique )
    }
}
