import RegexBuilder
import Foundation

public extension Regex {
    static func ~=(regex: Self, input: String) -> Bool {
        input.wholeMatch(of: regex) != nil
    }

    static func ~=(regex: Self, input: Substring) -> Bool {
        input.wholeMatch(of: regex) != nil
    }
}

public extension Locale {
    static var english = Locale(identifier: "en-US")
}

public extension RegexComponent where Self == Integer {
    static var integer: Self {
        Integer()
    }
}

public struct Integer: RegexComponent {
    public typealias RegexOutput = Int

    public init() {}

    public var regex: Regex<Int> {
        Regex {
            .localizedInteger(locale: .english).grouping(.never).sign(strategy: .automatic)
        }
    }
}

extension Regex.Match {

}
