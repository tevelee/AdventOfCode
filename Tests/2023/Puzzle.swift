import Utils
import XCTest

protocol Puzzle {
    init(_ input: Input) throws
    static var year: Int { get }
    static var day: Int { get }
}

extension Puzzle {
    private static var className: String {
        String(reflecting: Self.self)
    }

    static var day: Int {
        className.integers.last!
    }

    static var year: Int {
        className.integers.first!
    }
}

extension Puzzle {
    init() throws {
        try self.init(file("\(Self.year)_day\(Self.day)"))
    }
}

func file(_ fileName: String, fileExtension: String = "txt") throws -> Input {
    try .contentsOfFile(XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension)))
}
