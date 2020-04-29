import UIKit
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        enableUiTestModeIfAppropriate()
        
        let coordinator: Coordinator = Resolver.resolve()
        let viewController = coordinator.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
        
        let syncManager: SyncManager = Resolver.resolve()
        syncManager.startSync()

        return true
    }
    
    func enableUiTestModeIfAppropriate() {
        guard CommandLine.arguments.contains("-uitest") else { return }
        
        let configuration: Configuration = Resolver.resolve()
        configuration.useMockApi()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let syncManager: SyncManager = Resolver.resolve()
        syncManager.startSync()
    }
}
