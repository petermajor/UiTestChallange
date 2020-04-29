import Foundation
import Cucumberish

@objc class CucumberishInitializer: NSObject {
    @objc class func setupCucumberish()
    {
        beforeStart { () -> Void in
            HomeScreen().register()
        }
        
        before { x -> Void in
            
            try! MockServer.instance.start()
            let app = XCUIApplication()
            app.launchArguments.append("-uitest")
            app.launch()
        }
        
        after { _ -> Void in
            MockServer.instance.stop()
        }

        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: nil, excludeTags: ["disabled"])
    }
}
