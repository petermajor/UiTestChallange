import Foundation

class Configuration {
    private(set) var baseRegionalUrl: URL = URL(string: "https://fdp-regional-v1-0.gcprod1.freetime-platform.net/ms2/regional")!
    private(set) var baseImageUrl: URL = URL(string: "https://fdp-sv15-image-v1-0.gcprod1.freetime-platform.net/cache")!
    
    func useMockApi() {
        baseRegionalUrl = URL(string: "http://localhost:6854/regional")!
        baseImageUrl = URL(string: "http://localhost:6854/images")!
    }
}
