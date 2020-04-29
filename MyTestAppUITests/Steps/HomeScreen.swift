import Cucumberish
import Foundation
import XCTest

class HomeScreen {
    
    let featuredItemIndexTagline = 0
    let featuredItemIndexName = 1
    let featuredItemIndexSubtitle = 2

    // MARK: - Selectors
    
    func instance() -> XCUIElement {
        return XCUIApplication().otherElements["HomeViewController"]
    }
    
    func featuredCells() -> XCUIElementQuery {
        return XCUIApplication()
            .cells
            .matching(identifier: "FeaturedCell")
    }

    func featuredCellWithValues(tagline: String, name: String, subtitle: String) -> XCUIElement {
        return featuredCells()
            .containing(NSPredicate(format: "identifier = %@ AND label = %@", "TaglineLabel", tagline))
            .containing(NSPredicate(format: "identifier = %@ AND label = %@", "NameLabel", name))
            .containing(NSPredicate(format: "identifier = %@ AND label = %@", "SubtitleLabel", subtitle))
            .element
    }

    // MARK: - Steps
    
    func register() {
        
        GivenWhenThen("Home Screen is showing") { _, _ in
            self.instance().waitForElementToAppear()
        }

        GivenWhenThen("I swipe left on Featured items") { _, _ in
            let window = XCUIApplication().windows.element(boundBy: 0)
            // must swipe on the fully visible cell, swiping on the peeking cell doesn't work
            for element in self.featuredCells().allElementsBoundByIndex {
                if window.frame.contains(element.frame) {
                    element.swipeLeft()
                    return
                }
            }
        }

        GivenWhenThen("visible Featured items are") { args, userInfo in
            guard let userInfo = userInfo else { fatalError("unable to get userInfo") }
            guard let dataTable = userInfo["DataTable"] as? [[String]] else { fatalError("unable to get datatable") }
            
            for values in dataTable {
                let tagline = values[self.featuredItemIndexTagline]
                let name = values[self.featuredItemIndexName]
                let subtitle = values[self.featuredItemIndexSubtitle]
                
                self.featuredCellWithValues(tagline: tagline, name: name, subtitle: subtitle).waitForElementToAppear()
            }
            
            let actualCount = self.featuredCells().count
            XCTAssertEqual(dataTable.count, actualCount, "Expected cell count \(dataTable.count), actual cell count \(actualCount)")
            
            //print(XCUIApplication().debugDescription)
        }
    }
}
