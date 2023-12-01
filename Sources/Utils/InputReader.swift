import Foundation
import Algorithms

public enum Input {
    case string(String)
    case url(URL)

    @inlinable public var wholeInput: String {
        get throws {
            switch self {
            case .string(let value):
                return value
            case .url(let url):
                return try String(contentsOf: url)
            }
        }
    }

    @inlinable public var lines: AnyAsyncSequence<String> {
        switch self {
        case .string(let value):
            return value.lines(includeEmptyLines: true).async.eraseToAnyAsyncSequence()
        case .url(let url):
            return url.lines.eraseToAnyAsyncSequence()
        }
    }
}

extension Input: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}
