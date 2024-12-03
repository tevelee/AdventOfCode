import Utils
import RegexBuilder

public final class AoC_2024_Day3 {
    private let instructions: String

    private lazy var number = TryCapture {
        Repeat(1...3) {
            One(.digit)
        }
    } transform: {
        Int($0)
    }

    private lazy var mul = Regex {
        "mul("
        number
        ","
        number
        ")"
    }

    public init(_ input: Input) throws {
        instructions = try input.wholeInput
    }

    public func solvePart1() async throws -> Int {
        instructions.matches(of: mul).sum { match in
            match.1 * match.2
        }
    }

    public func solvePart2() async throws -> Int {
        let full = Regex {
            ChoiceOf {
                "do()"
                "don't()"
                mul
            }
        }

        var enabled = true
        return instructions.matches(of: full).sum { match in
            switch match.output {
                case ("do()", _, _):
                    enabled = true
                case ("don't()", _, _):
                    enabled = false
                case (_, let lhs?, let rhs?) where enabled:
                    return lhs * rhs
                default:
                    break
            }
            return 0
        }
    }
}
