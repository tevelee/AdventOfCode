@testable import AoC_2023
import Foundation
import Testing
import XCTest

final class AoC_2023_Tests: XCTestCase {
    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
}
