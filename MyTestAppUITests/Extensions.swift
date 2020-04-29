import XCTest

extension XCUIElement{
    func waitForElementToAppear(timeout: TimeInterval = 10) {
        let predicate = NSPredicate(format: "exists == 1")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        guard result == .completed else {
            XCTFail("Element did not appear: \(self.debugDescription)")
            return
        }
    }
}

// the "MatchAll" function does actually match Given... so it's "MatchAllKinda" really
func GivenWhenThen(_ definitionString: String, _ body: @escaping CCIStepBody)
{
    Given(definitionString, body);
    When(definitionString, body);
    Then(definitionString, body);
}

extension Date {
    static func build(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Int) -> Date? {
        let calendar = Calendar.current
        let dateComponents = DateComponents(
            calendar: calendar,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second)
        return calendar.date(from: dateComponents)!
    }
}
