import Graphs
import Utils

public final class AoC_2024_Day16 {
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

    private lazy var graph = LazyIncidenceGraph(neighbors: { [walls] (node: Node) in
        node.neighbors.filter { !walls.contains($0.position) }
    })
    .withEdgeProperty(for: Weight.self) { edge, _ in
        edge.source.direction == edge.destination.direction ? 1 : 1001
    }

    public func solvePart1() -> UInt {
        guard let path = graph.shortestPath(
            from: Node(position: start, direction: .east),
            until: { [end] in $0.position == end },
            using: .dijkstra(weight: .property(\.weight))
        ) else { return 0 }
        return path.edges.reduce(0) { $0 + graph[$1].weight }
    }

    public func solvePart2() -> Int {
        let paths = graph.allShortestPaths(
            from: Node(position: start, direction: .east),
            until: { [end] in $0.position == end },
            weight: .property(\.weight)
        )
        return Set(paths.flatMap(\.vertices)).count - (paths.count + 1) / 2
    }
}

private struct Node: Hashable, CustomStringConvertible {
    let position: Position
    let direction: Direction

    var neighbors: [Node] {
        position.neighbors.filter { $0.direction != direction.opposite }
    }

    var description: String {
        "(\(position.x),\(position.y)) \(direction)"
    }
}

private enum Direction: Hashable {
    case north, east, south, west

    var opposite: Direction {
        switch self {
            case .north: .south
            case .east: .west
            case .south: .north
            case .west: .east
        }
    }
}

private struct Position: Hashable {
    let x, y: Int

    var neighbors: [Node] {
        [
            Node(position: Position(x: x, y: y - 1), direction: .north),
            Node(position: Position(x: x + 1, y: y), direction: .east),
            Node(position: Position(x: x, y: y + 1), direction: .south),
            Node(position: Position(x: x - 1, y: y), direction: .west),
        ]
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
