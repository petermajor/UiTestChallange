## UiTestChallange

#### Overview

The is an app built I built to explore how I might implement UI tests for an app that calls an API with temporal data (i.e. the tests would not be reliably repeatable). I wanted to see how easy it would be to spin up a mock HTTP API and get the app to call that instead.

The main page of the app is a collection view containing multiple orthoginal scrolling layouts. The app has a target SDK of 13.0, since I originally built this app to investigate `UICollectionViewDiffableDataSource` and `UICollectionViewCompositionalLayout`

#### How to run the app
- Clone the app
- Open `MyTestApp.xcworkspace` in Xcode
- Build and run!

#### How to run the tests (in Xcode)
- Run the app first to make sure it's working
- Build the UI test target (Command-Shift-U)
- Run the UI test target (Command-U)

#### How to run the tests (from command line)
- Open terminal
- Navigate to the root folder
- Execute `xcodebuild -workspace MyTestApp.xcworkspace -scheme "MyTestApp" -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max' test`


#### Considerations
There's a bunch of things to consider when writing UI tests:
- Whether to use real API, mock API, or stubbed network calls? I wrote these sample tests using a *Mock API*, mostly because the test data for the app changes over time.
- Whether to use XCUITest or something based on Selenium (like Appium)? I would prefer XCUITest and writing tests in Swift, but it's worth having further discussion on this.
- Whether to write the UI tests in code or use a BDD tool like Cucumber? In this demo I used feature files to define the tests and Cucumberish to implement the steps, but whether this adds value is worth considering further.
- Whether to run on device or simulator? For this demo I've just used the simulator, but for real test it may be worth considering real devices.

#### Mock API
If you run the app in the simulator you will notice that the data shown in different that if you run the UI tests. The live data is sourced from the TV Guide API and is highly variable from day to day. This would make writing repeatable UI tests difficult for this dataset.
I've mocked out the API with a local micro http server that is controlled in the UI tests. This means you can control the data that is served to the app while the tests are running, while still testing the network layer of the app.
In this demo the data served by the mock is static, but in a real implementation it would be configured as part of the test, so you could test scenarios with different data, error conditions etc.
