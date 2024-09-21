public struct GridGraph<Value, Edge>: GraphProtocol {
    public struct Node {
        public let position: GridPosition
        public let value: Value

        @inlinable public init(position: GridPosition, value: Value) {
            self.position = position
            self.value = value
        }
    }

    public let grid: [[Value]]
    public let availableDirections: [GridDirection]
    @usableFromInline let edge: (Node, Node) -> Edge

    @inlinable public init(
        grid: [some Sequence<Value>],
        availableDirections: [GridDirection] = GridDirection.allCases,
        edge: @escaping (Node, Node) -> Edge
    ) {
        self.grid = grid.map(Array.init)
        self.availableDirections = availableDirections
        self.edge = edge
    }

    @inlinable public init(
        grid: [some Sequence<Value>],
        availableDirections: [GridDirection] = GridDirection.allCases
    ) where Edge == Void {
        self.init(grid: grid, availableDirections: availableDirections) { _, _ in () }
    }

    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        edges(from: node.position)
    }

    @inlinable public func edges(from position: GridPosition) -> [GraphEdge<Node, Edge>] {
        grid.neighbors(of: position, in: availableDirections)
            .map {
                GraphEdge(source: self[position], destination: self[$0], value: edge(self[position], self[$0]))
            }
    }

    @inlinable public subscript(position: GridPosition) -> Value {
        grid[position]
    }

    @inlinable public subscript(position: GridPosition) -> Node {
        Node(position: position, value: grid[position])
    }
}

extension WeightedGraph {
    @inlinable public func shortestPath<Value, PreviousEdge>(
        from source: GridPosition,
        to destination: GridPosition,
        using algorithm: some ShortestPathAlgorithm<Node, Edge>
    ) -> Path<Node, Edge>? where Graph == GridGraph<Value, PreviousEdge> {
        algorithm.shortestPath(
            in: self,
            from: Node(position: source, value: graph.grid[source]),
            to: Node(position: destination, value: graph.grid[destination])
        )
    }

    @inlinable public func shortestPath<Value: Hashable, PreviousEdge>(
        from source: GridPosition,
        to destination: GridPosition
    ) -> Path<Node, Edge>? where Graph == GridGraph<Value, PreviousEdge>, Edge.Weight: Numeric {
        self.shortestPath(from: source, to: destination, using: .dijkstra())
    }

    @inlinable public func shortestPaths<Value, PreviousEdge>(
        from source: GridPosition,
        using algorithm: some ShortestPathsAlgorithm<Node, Edge>
    ) -> [Node: Path<Node, Edge>] where Graph == GridGraph<Value, PreviousEdge> {
        algorithm.shortestPaths(
            in: self,
            from: Node(position: source, value: graph.grid[source])
        )
    }

    @inlinable public func shortestPaths<Value: Hashable, PreviousEdge>(
        from source: GridPosition
    ) -> [Node: Path<Node, Edge>] where Graph == GridGraph<Value, PreviousEdge>, Edge.Weight: Numeric {
        self.shortestPaths(from: source, using: .dijkstra())
    }
}

extension GridGraph.Node: Equatable where Value: Equatable {}
extension GridGraph.Node: Hashable where Value: Hashable {}

public struct GridPosition: Hashable {
    public let x, y: Int

    @inlinable public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    @inlinable public func move(_ movement: GridMovement) -> Self {
        GridPosition(
            x: x + movement.x,
            y: y + movement.y
        )
    }

    @inlinable public var coordinates: SIMD2<Double> {
        SIMD2(Double(x), Double(y))
    }
}

public struct GridMovement: Hashable {
    public let x, y: Int

    @inlinable public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    @inlinable public func repeated(times count: Int) -> GridMovement {
        GridMovement(
            x: x * count,
            y: y * count
        )
    }
}

public enum GridDirection: CaseIterable, Sendable {
    case up, left, down, right
    case upLeft, downLeft, upRight, downRight

    @inlinable public var movement: GridMovement {
        switch self {
        case .up: GridMovement(x: 0, y: -1)
        case .down: GridMovement(x: 0, y: 1)
        case .left: GridMovement(x: -1, y: 0)
        case .right: GridMovement(x: 1, y: 0)
        case .upLeft: GridMovement(x: -1, y: -1)
        case .upRight: GridMovement(x: 1, y: -1)
        case .downLeft: GridMovement(x: -1, y: 1)
        case .downRight: GridMovement(x: 1, y: 1)
        }
    }
}

extension [GridDirection] {
    public static let horizontal: [GridDirection] = [.left, .right]
    public static let vertical: [GridDirection] = [.up, .down]
    public static let orthogonal: [GridDirection] = [.right, .down, .left, .up]
    public static let diagonal: [GridDirection] = [.upRight, .downRight, .downLeft, .upLeft]
}

extension Array where Element: Collection, Element.Index == Int {
    @inlinable public var positions: some Sequence<GridPosition> {
        self.lazy.enumerated().flatMap { x, line in
            line.indices.lazy.map { GridPosition(x: x, y: $0) }
        }
    }

    @inlinable public subscript(position: GridPosition) -> Element.Element {
        self[position.y][position.x]
    }

    @inlinable public subscript(infinite position: GridPosition) -> Element.Element {
        let row = nonNegativeModulo(of: position.y, by: count)
        let column = nonNegativeModulo(of: position.x, by: self[row].count)
        return self[row][column]
    }

    @inlinable public subscript(safe position: GridPosition) -> Element.Element? {
        self[safe: position.y]?[safe: position.x]
    }

    @inlinable public func neighbors(of position: GridPosition, in directions: some Sequence<GridDirection>) -> some Sequence<GridPosition> {
        directions.lazy.map(\.movement).map(position.move).filter(contains)
    }

    @inlinable public func contains(position: GridPosition) -> Bool {
        indices.contains(position.y) && self[position.y].indices.contains(position.x)
    }
}
