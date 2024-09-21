extension GraphProtocol {
    @inlinable public func traversal<Visit, Strategy: GraphTraversalStrategy<Node, Edge, Visit>>(from node: Node, strategy: Strategy) -> GraphTraversal<Self, Strategy> {
        .init(graph: self, startNode: node, strategy: strategy)
    }

    @inlinable public func traverse<Visit>(from node: Node, strategy: some GraphTraversalStrategy<Node, Edge, Visit>) -> [Visit] {
        Array(traversal(from: node, strategy: strategy))
    }
}

public struct GraphTraversal<Graph: GraphProtocol, Strategy: GraphTraversalStrategy>: Sequence where Graph.Node == Strategy.Node, Graph.Edge == Strategy.Edge {
    typealias Node = Graph.Node
    typealias Edge = Graph.Edge

    @usableFromInline let graph: Graph
    @usableFromInline let startNode: Graph.Node
    @usableFromInline var strategy: Strategy

    @inlinable public init(graph: Graph, startNode: Graph.Node, strategy: Strategy) {
        self.graph = graph
        self.startNode = startNode
        self.strategy = strategy
    }

    public struct Iterator: IteratorProtocol {
        @usableFromInline let graph: Graph
        @usableFromInline var storage: Strategy.Storage
        @usableFromInline var strategy: Strategy

        @inlinable public init(graph: Graph, startNode: Graph.Node, strategy: Strategy) {
            self.graph = graph
            self.strategy = strategy
            self.storage = strategy.initializeStorage(startNode: startNode)
        }

        @inlinable public mutating func next() -> Strategy.Visit? {
            strategy.next(from: &storage, graph: graph)
        }
    }

    @inlinable public func makeIterator() -> Iterator {
        Iterator(graph: graph, startNode: startNode, strategy: strategy)
    }
}
