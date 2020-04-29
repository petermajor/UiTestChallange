Feature: Home Screen

Scenario: Initial Featured items
    Given Home Screen is showing
    Then visible Featured items are
    | FEATURED | Grand Tours of Scotland's Lochs | 2/26/20, 7:30 PM |
    | FEATURED | Bargain-Loving Brits In...      | 2/27/20, 8:00 PM |

Scenario: Swiping left on Featured items
    Given Home Screen is showing
    And visible Featured items are
    | FEATURED | Grand Tours of Scotland's Lochs | 2/26/20, 7:30 PM |
    | FEATURED | Bargain-Loving Brits In...      | 2/27/20, 8:00 PM |
    When I swipe left on Featured items
    And visible Featured items are
    | FEATURED | Grand Tours of Scotland's Lochs | 2/26/20, 7:30 PM |
    | FEATURED | Bargain-Loving Brits In...      | 2/27/20, 8:00 PM |
    | FEATURED | The Truth About Takeaways       | 3/1/20, 9:00 PM  |
    When I swipe left on Featured items
    Then visible Featured items are
    | FEATURED | Bargain-Loving Brits In...      | 2/27/20, 8:00 PM |
    | FEATURED | The Truth About Takeaways       | 3/1/20, 9:00 PM  |
