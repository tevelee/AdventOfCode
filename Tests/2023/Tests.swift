@testable import AoC_2023
import Testing
import XCTest

final class AoC_2023_Tests: XCTestCase {
    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
}

func file(_ fileName: String, fileExtension: String = "txt") throws -> Input {
    try .url(XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension)))
}
