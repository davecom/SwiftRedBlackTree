import XCTest
@testable import SwiftRedBlackTree

class SwiftRedBlackTreeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        var tree = RBTree<Int>()
        for i in 0...1000000 {
            tree.insert(i)
        }
        let has2000 = tree.contains(1000000)
        XCTAssert(has2000)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
