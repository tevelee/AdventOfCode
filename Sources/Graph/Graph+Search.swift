extension GraphProtocol {
    @inlinable public func searchFirst<Visit>(from node: Node, strategy: some GraphTraversalStrategy<Node, Edge, Visit>, goal: (Visit) -> Bool) -> Visit? {
        traversal(from: node, strategy: strategy).first(where: goal)
    }

    @inlinable public func searchAll<Visit>(from node: Node, strategy: some GraphTraversalStrategy<Node, Edge, Visit>, goal: (Visit) -> Bool) -> [Visit] {
        traversal(from: node, strategy: strategy).filter(goal)
    }
}
