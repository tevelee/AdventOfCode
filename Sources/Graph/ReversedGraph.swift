public struct ReversedGraph<Base: FullGraphProtocol>: FullGraphProtocol where Base.Node: Equatable {
    public typealias Node = Base.Node
    public typealias Edge = Base.Edge

    @usableFromInline let base: Base

    @inlinable public init(base: Base) {
        self.base = base
    }

    public var allNodes: [Base.Node] {
        base.allNodes
    }

    public var allEdges: [GraphEdge<Base.Node, Base.Edge>] {
        base.allEdges.map { GraphEdge(source: $0.destination, destination: $0.source, value: $0.value) }
    }
}
