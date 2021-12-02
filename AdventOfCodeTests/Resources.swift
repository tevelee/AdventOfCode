import Foundation
import XCTest

final class Resources {
    static func url(for fileName: String, fileExtension: String = "txt") throws -> URL {
        try XCTUnwrap(Bundle(for: self).url(forResource: fileName, withExtension: fileExtension))
    }
}
