import AoC_2023
import Foundation
import Testing
import XCTest

final class AoC_2023_Tests: XCTestCase {
#if swift(<6.0)
    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
#endif
}

extension Tag {
    @Tag static var live: Tag
}
