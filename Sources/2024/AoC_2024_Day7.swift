import Utils

public final class AoC_2024_Day7 {
    private let entries: [(target: Int, components: [Int])]

    public init(_ input: Input) throws {
        entries = try input.wholeInput.lines.map { line in
            guard let (target, others) = line.integers.headAndTail else { throw ParseError() }
            return (target, Array(others))
        }
    }

    public func solvePart1() -> Int {
        solve(operators: [.multiply, .add])
    }

    public func solvePart2() -> Int {
        solve(operators: [.multiply, .add, .append])
    }

    private func solve(operators: [Operator]) -> Int {
        entries.sum { entry in
            canSolve(target: entry.target, components: entry.components, operators: operators) ? entry.target : 0
        }
    }

    private func canSolve(target: Int, components: some Sequence<Int>, operators: [Operator]) -> Bool {
        guard let (first, components) = components.headAndTail, first <= target else { return false }
        guard let (second, components) = components.headAndTail else { return target == first }
        for op in operators where canSolve(target: target, components: op.perform(first, second) + components, operators: operators) {
            return true
        }
        return false
    }
}

private struct Operator {
    let perform: @Sendable (Int, Int) -> Int

    static let add = Operator { $0 + $1 }
    static let multiply = Operator { $0 * $1 }
    static let append = Operator { Int("\($0)\($1)")! }
}
