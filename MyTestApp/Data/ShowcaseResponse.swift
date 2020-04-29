import Foundation

struct ShowcaseResponse: Codable {
    let refreshDateTime: Date
    let showcase_events: [ShowcaseEvent]
    let pages: [ShowcasePage]
}

struct ShowcaseEvent: Codable {
    let svcId: Int
    let evtId: Int
    let sc_title: String
    let sc_description: String
    let sc_image: String
    let startTime: Date
    let duration: Int
}

struct ShowcasePage: Codable {
    let title: String
    let filters: [ShowcaseFilter]
    let startfilter: Int
}

struct ShowcaseFilter: Codable {
    let id: Int
    let name: String
    let events: [ShowcaseFilterEvent]
}

struct ShowcaseFilterEvent: Codable {
    let id: Int
    let svcId: Int
    let evtId: Int
}
