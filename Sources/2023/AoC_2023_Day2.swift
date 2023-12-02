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
            let (red, green, blue) = game.sessions.reduce((red: 0, green: 0, blue: 0)) { result, session in
                (max(result.red, session.red), max(result.green, session.green), max(result.blue, session.blue))
            }
            return red * green * blue
        }
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

