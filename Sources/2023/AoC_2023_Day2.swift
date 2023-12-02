import Algorithms
import RegexBuilder

final class AoC_2023_Day2 {
    fileprivate let games: [Game]

    init(_ input: Input) throws {
        games = try input.wholeInput.lines.compactMap(Game.init)
    }

    func solvePart1() -> Int {
        games.filter { game in
            game.sessions.allSatisfy {
                $0.red <= 12 && $0.green <= 13 && $0.blue <= 14
            }
        }
        .sum(of: \.id)
    }

    func solvePart2() -> Int {
        games.sum { game in
            let (red, green, blue) = max(of: game.sessions, for: \.red, \.green, \.blue)
            return product(of: (red, green, blue))
        }
    }

    private func max<Root, each Value: Numeric & Comparable>(
        of root: some Collection<Root>,
        for property: repeat KeyPath<Root, each Value>
    ) -> (repeat each Value) {
        perform(
            operation: repeat (Swift.max, (each Value).self).0, // `repeat Swift.max` cannot be written in source, the expression has to contain at least one pack reference. See the "Concrete pattern type" section of https://github.com/apple/swift-evolution/blob/main/proposals/0393-parameter-packs.md#pack-expansion-type
            on: root,
            for: repeat each property
        )
    }

    private func perform<Root, each Value: Numeric & Comparable>(
        operation: repeat @escaping (each Value, each Value) -> each Value,
        on root: some Collection<Root>,
        for property: repeat KeyPath<Root, each Value>
    ) -> (repeat each Value) {
        root.reduce((repeat (each Value).zero)) { (result: (repeat each Value), element) in
            (repeat (each operation)(each result, element[keyPath: each property]))
        }
    }

    private func product<each Value>(of element: (repeat each Value)) -> Int /* where repeat each Value == Int */ {
        var value = 1
        repeat value *= each element as! Int // Same-element requirement is not yet implemented in Swift 5.9
        return value
    }
}

private struct Game {
    let id: Int
    let sessions: [Session]

    struct Session {
        let red: Int
        let green: Int
        let blue: Int
    }

    init?(raw: String) {
        guard let match = raw.wholeMatch(of: /Game (?<id>\d+): (?<sessions>.*)/),
            let id = Int(match.id) else { return nil }
        self.id = id
        self.sessions = match.sessions.split(separator: "; ").map { rawSession in
            Session(
                red: Self.parseNumber(of: "red", from: rawSession),
                green: Self.parseNumber(of: "green", from: rawSession),
                blue: Self.parseNumber(of: "blue", from: rawSession)
            )
        }
    }

    private static func parseNumber(of color: String, from input: Substring, defaultValue: Int = 0) -> Int {
        input.firstMatch(of: Regex {
            Capture {
                OneOrMore {
                    .digit
                }
            } transform: { value in
                Int(value)
            }
            " "
            color
        })?.output.1 ?? defaultValue
    }
}

