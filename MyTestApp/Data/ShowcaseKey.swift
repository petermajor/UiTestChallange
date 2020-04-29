struct ShowcaseEventKey: Hashable {
    let svcId: Int
    let evtId: Int
}

extension ShowcaseEvent {
    var key: ShowcaseEventKey { ShowcaseEventKey(svcId: svcId, evtId: evtId) }
}

extension ShowcaseFilterEvent {
    var key: ShowcaseEventKey { ShowcaseEventKey(svcId: svcId, evtId: evtId) }
}
