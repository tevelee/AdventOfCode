import Utils

public final class AoC_2025_Day1 {
    private let values: AnyAsyncSequence<Int>
    private let dialSize = 100

    public init(_ input: Input) {
        values = input.lines
            .compactMap { line -> Int? in
                guard let match = try /(?<direction>L|R)(?<value>\d+)/.wholeMatch(in: line)?.output, let value = Int(match.value) else {
                    throw ParseError("invalid input line")
                }
                return switch match.direction {
                    case "L": -value
                    case "R": value
                    default: throw ParseError("invalid direction")
                }
            }
            .eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await solve { position, rotation in
            (position + rotation).isMultiple(of: dialSize) ? 1 : 0
        }
    }

    public func solvePart2() async throws -> Int {
        try await solve { position, rotation in
            let sign = rotation.signum()
            return revolutions((position + rotation) * sign) - revolutions(position * sign)
        }
    }
    
    private func solve(
        startingPosition: Int = 50,
        increment: (_ position: Int, _ rotation: Int) -> Int
    ) async throws -> Int {
        var current = startingPosition
        var result = 0
        for try await rotation in values {
            result += increment(current, rotation)
            current += rotation
        }
        return result
    }
    
    private func revolutions(_ x: Int) -> Int {
        floorDiv(x, dialSize)
    }
}
