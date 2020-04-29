import Foundation
import HttpSwift

class MockServer {
    private(set) static var instance: MockServer = MockServer()
    
    let port: UInt16 = 6854
    private(set) var started = false

    private let server: Server
    
    init() {
        server = Server()
        registerRoutes()
    }
    
    func registerRoutes() {
        
        server.get("regional/sc/json/{batId}/{regionId}") { request in
            
            let events = [
                ShowcaseEvent(svcId: 1, evtId: 1, sc_title: "Grand Tours of Scotland's Lochs", sc_description: "", sc_image: "featured1.png", startTime: Date.build(2020, 2, 26, 19, 30, 0)!, duration: 60),
                ShowcaseEvent(svcId: 1, evtId: 2, sc_title: "Bargain-Loving Brits In...", sc_description: "", sc_image: "featured2.png", startTime: Date.build(2020, 2, 27, 20, 0, 0)!, duration: 60),
                ShowcaseEvent(svcId: 1, evtId: 3, sc_title: "The Truth About Takeaways", sc_description: "", sc_image: "featured3.png", startTime: Date.build(2020, 3, 1, 21, 0, 0)!, duration: 60)
            ]
            
            let featuredPageFilter = ShowcaseFilter(id: 1, name: "all", events: [ShowcaseFilterEvent(id: 1, svcId: 1, evtId: 1), ShowcaseFilterEvent(id: 1, svcId: 1, evtId: 2), ShowcaseFilterEvent(id: 1, svcId: 1, evtId: 3)])
            let featuredPage = ShowcasePage(title: "on tv", filters: [featuredPageFilter], startfilter: 1)
            
            let pages = [
                featuredPage
            ]
            
            let response = ShowcaseResponse(refreshDateTime: Date(), showcase_events: events, pages: pages)
            
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .secondsSince1970
                //encoder.keyEncodingStrategy = .convertFromSnakeCase
                let data = try encoder.encode(response)
                
                return .init(.ok, body: [Byte](data), headers: ["Content-Type": "application/json"])
            } catch {
                return .init(.internalServerError)
            }
        }
        
        if let baseResourcePath = Bundle.init(for: MockServer.self).resourcePath {
            let staticResourceUrl = baseResourcePath + "/Static"
            server.get("images/{path}") { request in
                return try StaticServer.serveFile(in: staticResourceUrl, path: request.fullPath)
            }
        }
    }
    
    func start() throws {
        guard !started else { return }
        try server.run(port: port, address: nil, certifiatePath: nil)
        started = true
    }
    
    func stop() {
        guard started else { return }
        server.stop()
        started = false
    }
}
