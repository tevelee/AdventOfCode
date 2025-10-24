import Algorithms
import Graphs
import Utils

public final class AoC_2024_Day20 {
    private let walls: Set<Position>
    private let start: Position
    private let end: Position

    public init(_ input: Input) throws {
        var walls: Set<Position> = []
        var start: Position?
        var end: Position?
        for (row, line) in try input.wholeInput.lines.enumerated() {
            for (column, character) in line.enumerated() {
                let position = Position(x: column, y: row)
                switch character {
                case "#": walls.insert(position)
                case "S": start = position
                case "E": end = position
                default: break
                }
            }
        }
        self.walls = walls
        guard let start, let end else { throw ParseError() }
        self.start = start
        self.end = end
    }

    public func solvePart1() -> Int {
        solve(max: 2) { $0 >= 100 }
    }

    public func solvePart2() -> Int {
        solve(max: 20) { $0 >= 100 }
    }

    public func solve(max: Int, saves: Int) -> Int {
        solve(max: max) { $0 == saves }
    }

    private lazy var shortestPath = LazyIncidenceGraph(neighbors: { [walls] (pos: Position) in pos.neighbors.filter { !walls.contains($0) } })
        .withEdgeProperty(for: Weight.self) { _, _ in 1 }
        .shortestPath(from: start, to: end, using: .dijkstra(weight: .property(\.weight)))!
        .vertices

    private lazy var offsets: [Position: Int] = {
        Dictionary(uniqueKeysWithValues: shortestPath.enumerated().map { ($0.element, $0.offset) })
    }()

    private func solve(max maxLength: Int, saveCondition: @escaping (Int) -> Bool) -> Int {
        shortestPath
            .combinations(ofCount: 2)
            .map { try! $0.elements() }
            .count { [walls] (p1: Position, p2: Position) in
                let length = abs(p1.x - p2.x) + abs(p1.y - p2.y) - 1
                guard length > 0, length < maxLength else { return false }
                let saving = abs(offsets[p1]! - offsets[p2]!) - length - 1
                guard saveCondition(saving) else { return false }
                let graph = LazyIncidenceGraph(neighbors: { (pos: Position) in
                    pos.neighbors.filter { walls.contains($0) || $0 == p2 }
                })
                let path = graph.shortestPath(
                    from: p1,
                    to: p2,
                    using: .aStar(
                        weight: .uniform(1),
                        heuristic: .distance(to: p2, using: .manhattan(\.coordinate))
                    )
                )
                return path != nil
            }
    }

    private func visualize(shortcut: [Position] = []) {
        let x = walls.minAndMaxValues(of: \.x)!
        let y = walls.minAndMaxValues(of: \.y)!
        for y in y.min ... y.max {
            for x in x.min ... x.max {
                let position = Position(x: x, y: y)
                let character: Character = if shortcut.contains(position) {
                    "X"
                } else if walls.contains(position) {
                    "#"
                } else if position == start {
                    "S"
                } else if position == end {
                    "E"
                } else {
                    "."
                }
                print(character, terminator: "")
            }
            print()
        }
    }
}

private struct Position: Hashable, CustomStringConvertible {
    let x, y: Int

    var neighbors: [Position] {
        [
            Position(x: x, y: y - 1),
            Position(x: x + 1, y: y),
            Position(x: x, y: y + 1),
            Position(x: x - 1, y: y)
        ]
    }

    var coordinate: SIMD2<Double> {
        .init(x: Double(x), y: Double(y))
    }

    var description: String {
        "(\(x),\(y))"
    }
}

private enum Weight: EdgeProperty {
    static let defaultValue: Double = 0
}

private extension EdgeProperties {
    var weight: Double {
        get { self[Weight.self] }
        set { self[Weight.self] = newValue }
    }
}
