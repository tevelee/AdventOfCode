import Utils

public final class AoC_2024_Day3 {
    private let instructions: String

    public init(_ input: Input) throws {
        instructions = try input.wholeInput
    }

    public func solvePart1() async throws -> Int {
        instructions.matches(of: /mul\((?<lhs>\d{1,3}),(?<rhs>\d{1,3})\)/).sum { match in
            guard let lhs = Int(match.lhs), let rhs = Int(match.rhs) else {
                return 0
            }
            return lhs * rhs
        }
    }

    public func solvePart2() async throws -> Int {
        var enabled = true
        return instructions.matches(of: /mul\((?<lhs>\d{1,3}),(?<rhs>\d{1,3})\)|do\(\)|don't\(\)/).sum { match in
            switch match.output {
                case ("do()", _, _):
                    enabled = true
                case ("don't()", _, _):
                    enabled = false
                case (_, let lhs?, let rhs?) where enabled:
                    if let lhs = Int(lhs), let rhs = Int(rhs) {
                        return lhs * rhs
                    }
                default:
                    break
            }
            return 0
        }
    }
}
