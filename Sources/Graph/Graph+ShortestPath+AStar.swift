import Collections

extension ShortestPathAlgorithm {
    @inlinable public static func aStar<Node, Edge: Weighted, Distance, Cost: Comparable>(heuristic: Self.Heuristic, calculateTotalCost: @escaping (Edge.Weight, Distance) -> Cost) -> Self where Self == AStarAlgorithm<Node, Edge, Distance, Cost> {
        .init(heuristic: heuristic, calculateTotalCost: calculateTotalCost)
    }

    @inlinable public static func aStar<Node, Edge: Weighted>(heuristic: Self.Heuristic) -> Self where Self == AStarAlgorithm<Node, Edge, Edge.Weight, Edge.Weight> {
        .init(heuristic: heuristic, calculateTotalCost: +)
    }

    @inlinable public static func aStar<Node, Edge: Weighted, Distance: BinaryFloatingPoint>(heuristic: Self.Heuristic) -> Self where Self == AStarAlgorithm<Node, Edge, Distance, Distance>, Edge.Weight: BinaryInteger {
        .init(heuristic: heuristic) { Distance($0) + $1 }
    }
}

extension AStarAlgorithm.Heuristic where HScore: FloatingPoint {
    @inlinable public static func eucledianDistance<Coordinate: SIMD>(of value: @escaping (Node) -> Coordinate) -> Self where HScore == Coordinate.Scalar {
        self.init(distanceAlgorithm: .eucledianDistance(of: value))
    }

    @inlinable public static func manhattanDistance<Coordinate: SIMD>(of value: @escaping (Node) -> Coordinate) -> Self where HScore == Coordinate.Scalar {
        self.init(distanceAlgorithm: .manhattanDistance(of: value))
    }
}

public struct AStarAlgorithm<Node: Hashable, Edge: Weighted, HScore, FScore: Comparable>: ShortestPathAlgorithm where Edge.Weight: Numeric {
    public struct Heuristic {
        public let estimatedDistance: (Node, Node) -> HScore

        @inlinable public init(estimatedDistance: @escaping (Node, Node) -> HScore) {
            self.estimatedDistance = estimatedDistance
        }

        @inlinable public init(distanceAlgorithm: DistanceAlgorithm<Node, HScore>) {
            self.init(estimatedDistance: distanceAlgorithm.distance)
        }
    }

    public typealias GScore = Edge.Weight

    @usableFromInline let heuristic: Heuristic
    @usableFromInline let calculateTotalCost: (GScore, HScore) -> FScore

    @inlinable public init(heuristic: Heuristic, calculateTotalCost: @escaping (GScore, HScore) -> FScore) {
        self.heuristic = heuristic
        self.calculateTotalCost = calculateTotalCost
    }

    @inlinable public func shortestPath(
        in graph: some GraphProtocol<Node, Edge>,
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? {
        var openSet = Heap<State>()
        var costs: [Node: GScore] = [source: .zero]
        var connectingEdges: [Node: GraphEdge<Node, Edge>] = [:]
        var closedSet: Set<Node> = []

        openSet.insert(
            State(
                node: source,
                costSoFar: .zero,
                estimatedTotalCost: calculateTotalCost(.zero, heuristic.estimatedDistance(source, destination))
            )
        )

        while let currentState = openSet.popMin() {
            let currentNode = currentState.node

            if currentNode == destination {
                return Path(connectingEdges: connectingEdges, source: source, destination: destination)
            }

            if !closedSet.insert(currentNode).inserted {
                continue
            }

            for edge in graph.edges(from: currentNode) {
                let neighbor = edge.destination
                let weight: Edge.Weight = edge.value.weight
                let newCost: GScore = currentState.costSoFar + weight

                if costs[neighbor] == nil || newCost < costs[neighbor]! {
                    costs[neighbor] = newCost
                    connectingEdges[neighbor] = edge
                    let estimatedTotalCost = calculateTotalCost(newCost, heuristic.estimatedDistance(neighbor, destination))
                    openSet.insert(State(node: neighbor, costSoFar: newCost, estimatedTotalCost: estimatedTotalCost))
                }
            }
        }

        return nil
    }

    @usableFromInline struct State: Comparable {
        @usableFromInline let node: Node
        @usableFromInline let costSoFar: GScore
        @usableFromInline let estimatedTotalCost: FScore

        @inlinable init(node: Node, costSoFar: GScore, estimatedTotalCost: FScore) {
            self.node = node
            self.costSoFar = costSoFar
            self.estimatedTotalCost = estimatedTotalCost
        }

        @inlinable public static func < (lhs: State, rhs: State) -> Bool {
            lhs.estimatedTotalCost < rhs.estimatedTotalCost
        }

        @inlinable public static func == (lhs: State, rhs: State) -> Bool {
            lhs.node == rhs.node &&
            lhs.estimatedTotalCost == rhs.estimatedTotalCost
        }
    }
}

extension SIMD where Scalar: FloatingPoint {
    @usableFromInline func abs() -> Self {
        pointwiseMax(.zero, self)
    }
}
