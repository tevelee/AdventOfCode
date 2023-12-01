import RegexBuilder
import Foundation

extension Regex {
    @inlinable public static func ~=(regex: Self, input: String) -> Bool {
        input.wholeMatch(of: regex) != nil
    }

    @inlinable public static func ~=(regex: Self, input: Substring) -> Bool {
        input.wholeMatch(of: regex) != nil
    }
}

extension Locale {
    public static let english = Locale(identifier: "en-US")
}

extension RegexComponent where Self == Integer {
    @inlinable public static var integer: Self {
        Integer()
    }
}

public struct Integer: RegexComponent {
    public typealias RegexOutput = Int

    @inlinable public init() {}

    @inlinable public var regex: Regex<Int> {
        Regex {
            .localizedInteger(locale: .english).grouping(.never).sign(strategy: .automatic)
        }
    }
}
