import Algorithms
import Utils

public final class AoC_2022_Day18 {
    private let input: Input

    public init(_ input: Input) throws {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await uncoveredSurfaces(of: input.lines.map(Position.init).eraseToAnyAsyncSequence())
    }

    public func solvePart2() async throws -> Int {
        let positions = try await Set(input.lines.map(Position.init).collect())

        let x = positions.map(\.x).minAndMax().map { ClosedRange(uncheckedBounds: (lower: $0.min - 1, upper: $0.max + 1)) }!
        let y = positions.map(\.y).minAndMax().map { ClosedRange(uncheckedBounds: (lower: $0.min - 1, upper: $0.max + 1)) }!
        let z = positions.map(\.z).minAndMax().map { ClosedRange(uncheckedBounds: (lower: $0.min - 1, upper: $0.max + 1)) }!
        let outerSurface = x.count * y.count * 2 + x.count * z.count * 2 + y.count * z.count * 2

        let outerPositions = explore(from: Position(x: x.lowerBound, y: y.lowerBound, z: z.lowerBound), excluding: positions) {
            x.contains($0.x) && y.contains($0.y) && z.contains($0.z)
        }
        let uncovered = try await uncoveredSurfaces(of: outerPositions.async.eraseToAnyAsyncSequence())
        return uncovered - outerSurface
    }

    private func uncoveredSurfaces(of inputPositions: AnyAsyncSequence<Position>) async throws -> Int {
        var uncoveredSurfaces = 0
        var positions: Set<Position> = []
        for try await position in inputPositions {
            let numberOfTouchingNeighbors = position.neighbors.intersection(positions).count
            uncoveredSurfaces += 6 - numberOfTouchingNeighbors * 2
            positions.insert(position)
        }
        return uncoveredSurfaces
    }

    private func explore(from origin: Position,
                         excluding excluded: Set<Position>,
                         constraint: (Position) -> Bool) -> Set<Position> {
        var visited: Set<Position> = []
        var toVisit = [origin]
        while let position = toVisit.popLast() {
            for neighbor in position.neighbors where constraint(neighbor) && !visited.contains(neighbor) && !excluded.contains(neighbor) {
                toVisit.append(neighbor)
            }
            visited.insert(position)
        }
        return visited
    }
}

private struct ParsingError: Error {}

private struct Position: Hashable {
    var x, y, z: Int

    private func apply(_ block: (inout Position) -> Void) -> Position {
        var copy = self
        block(&copy)
        return copy
    }

    var neighbors: Set<Position> {
        [
            apply { $0.x += 1 },
            apply { $0.x -= 1 },
            apply { $0.y += 1 },
            apply { $0.y -= 1 },
            apply { $0.z += 1 },
            apply { $0.z -= 1 }
        ]
    }
}

private extension Position {
    @Sendable
    init(parsing line: String) throws {
        guard let output = line.wholeMatch(of: /(\d+),(\d+),(\d+)/)?.output,
              let x = Int(output.1),
              let y = Int(output.2),
              let z = Int(output.3) else {
            throw ParsingError()
        }
        self.x = x
        self.y = y
        self.z = z
    }
}
