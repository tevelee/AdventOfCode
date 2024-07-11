import Foundation
import Algorithms

public enum Input: Sendable {
    case staticString(StaticString)
    case contentsOfFile(URL)

    @inlinable public var wholeInput: String {
        get throws {
            switch self {
            case .staticString(let value):
                return String(staticString: value)
            case .contentsOfFile(let url):
                return try String(contentsOf: url, encoding: .utf8)
            }
        }
    }

    @inlinable public var lines: some AsyncSequence<String, any Error> {
        switch self {
        case .staticString(let value):
            return String(staticString: value).lines(includeEmptyLines: true).async.eraseToAnyAsyncSequence()
        case .contentsOfFile(let url):
            return url.lines.eraseToAnyAsyncSequence()
        }
    }

    @inlinable public var characters: some AsyncSequence<Character, any Error> {
        switch self {
        case .staticString(let value):
            return Array(String(staticString: value)).async.eraseToAnyAsyncSequence()
        case .contentsOfFile(let url):
            return url.resourceBytes.characters.eraseToAnyAsyncSequence()
        }
    }
}

extension Input: ExpressibleByStringLiteral {
    @inlinable public init(stringLiteral value: StaticString) {
        self = .staticString(value)
    }
}

extension String {
    @usableFromInline init(staticString: StaticString) {
        self = staticString.withUTF8Buffer { buffer in
            String(decoding: buffer, as: UTF8.self)
        }
    }
}
