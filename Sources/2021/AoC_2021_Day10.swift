import Utils

public final class AoC_2021_Day10 {
    let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ contents: String) {
        lines = contents.lines.async.eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await lines
            .compactMap(invalidCharacter)
            .map(\.part1Score)
            .reduce(0, +)
    }

    public func solvePart2() async throws -> Int {
        let scores = try await lines
            .compactMap { line in
                self.missingBrackets(in: line)?.reduce(0) { result, bracket in
                    result * 5 + bracket.part2Score
                }
            }
            .collect()
            .sorted()
        return scores[Int(scores.count / 2)]
    }

    private func invalidCharacter(in line: String) -> Bracket? {
        if case .corrupted(let bracket) = process(line: line) {
            return bracket
        }
        return nil
    }

    private func missingBrackets(in line: String) -> [Bracket]? {
        if case .incomplete(let stack) = process(line: line) {
            return stack.reversed()
        }
        return nil
    }

    private func process(line: String) -> Validity {
        var counters: [Character: Int] = [:]
        var stack: [Bracket] = []
        let brackets = Bracket.allCases
        for character in line {
            if let bracket = brackets.first(where: { $0.literals.opening == character }) {
                counters[character, default: 0] += 1
                stack.append(bracket)
            } else if let bracket = brackets.first(where: { $0.literals.closing == character }) {
                counters[bracket.literals.opening, default: 0] -= 1
                if counters[bracket.literals.opening, default: 0] < 0 || stack.popLast() != bracket {
                    return .corrupted(invalidBracket: bracket)
                }
            } else {
                break
            }
        }
        if stack.isEmpty {
            return .valid
        } else {
            return .incomplete(stack: stack)
        }
    }

    enum Validity {
        case valid
        case corrupted(invalidBracket: Bracket)
        case incomplete(stack: [Bracket])
    }

    enum Bracket: Hashable, CaseIterable {
        case parentheses
        case square
        case curly
        case angle

        var literals: Literal {
            switch self {
                case .parentheses: return Literal(opening: "(", closing: ")")
                case .square: return Literal(opening: "[", closing: "]")
                case .curly: return Literal(opening: "{", closing: "}")
                case .angle: return Literal(opening: "<", closing: ">")
            }
        }

        var part1Score: Int {
            switch self {
                case .parentheses: return 3
                case .square: return 57
                case .curly: return 1197
                case .angle: return 25137
            }
        }

        var part2Score: Int {
            switch self {
                case .parentheses: return 1
                case .square: return 2
                case .curly: return 3
                case .angle: return 4
            }
        }
    }

    struct Literal: Hashable {
        let opening: Character
        let closing: Character
    }
}
