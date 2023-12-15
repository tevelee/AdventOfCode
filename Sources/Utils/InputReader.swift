import Foundation
import Algorithms

public enum Input {
    case staticString(StaticString)
    case contentsOfFile(URL)

    @inlinable public var wholeInput: String {
        get throws {
            switch self {
            case .staticString(let value):
                return String(staticString: value)
            case .contentsOfFile(let url):
                return try String(contentsOf: url)
            }
        }
    }

    @inlinable public var lines: AnyAsyncSequence<String> {
        switch self {
        case .staticString(let value):
            return String(staticString: value).lines(includeEmptyLines: true).async.eraseToAnyAsyncSequence()
        case .contentsOfFile(let url):
            return url.lines.eraseToAnyAsyncSequence()
        }
    }

    @inlinable public var characters: AnyAsyncSequence<Character> {
        switch self {
        case .staticString(let value):
            return Array(String(staticString: value)).async.eraseToAnyAsyncSequence()
        case .contentsOfFile(let url):
            return url.resourceBytes.characters.eraseToAnyAsyncSequence()
        }
    }
}

extension Input: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
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
