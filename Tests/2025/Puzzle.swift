import Foundation
import Testing
import Utils

protocol Puzzle {
    init(_ input: Input) async throws
    static var year: Int { get }
    static var day: Int { get }
}

extension Puzzle {
    private static var className: String {
        String(reflecting: Self.self)
    }

    @inlinable static var day: Int {
        className.integers.last!
    }

    @inlinable static var year: Int {
        className.integers.first!
    }
}

extension Puzzle {
    init() async throws {
        try await self.init(file("\(Self.year)_day\(Self.day)"))
    }
}

func file(_ fileName: String, fileExtension: String = "txt") throws -> Input {
    let url = try #require(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
    return .contentsOfFile(url)
}
