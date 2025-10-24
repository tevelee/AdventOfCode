import Graphs
import Utils

public final class AoC_2024_Day18 {
    private typealias Position = SIMD2<Int>
    private let range: ClosedRange<Int>
    private let positions: [Position]

    private lazy var topLeft = Position(x: range.lowerBound, y: range.lowerBound)
    private lazy var bottomRight = Position(x: range.upperBound, y: range.upperBound)

    public init(_ input: Input, range: ClosedRange<Int>) throws {
        self.range = range
        positions = try input.wholeInput.lines.map(\.integers).map(Position.init)
    }

    public func solvePart1(limit: Int) -> Int {
        shortestPath(limit: limit) ?? 0
    }

    public func solvePart2() -> String? {
        (0 ... positions.count)
            .reversed()
            .first { shortestPath(limit: $0) != nil }
            .map { "\(positions[$0].x),\(positions[$0].y)" }
    }

    private func shortestPath(limit: Int) -> Int? {
        let positions = Set(positions.prefix(limit))
        return LazyIncidenceGraph(neighbors: { self.neighbors($0).filter { !positions.contains($0) } })
            .shortestPath(from: topLeft, to: bottomRight, using: .dijkstra(weight: .unit))?
            .edges
            .count
    }

    private func neighbors(_ position: Position) -> some Sequence<Position> {
        [
            position.apply { $0.x += 1 },
            position.apply { $0.x -= 1 },
            position.apply { $0.y += 1 },
            position.apply { $0.y -= 1 }
        ]
        .filter(isWithinBounds)
    }

    private func isWithinBounds(_ position: Position) -> Bool {
        range.contains(position.x) && range.contains(position.y)
    }
}

private extension SIMD2 {
    func apply(block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

private enum Weight: EdgeProperty {
    static let defaultValue: UInt = 0
}

private extension EdgeProperties {
    var weight: UInt {
        get { self[Weight.self] }
        set { self[Weight.self] = newValue }
    }
}
