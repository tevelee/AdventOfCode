extension FullGraphProtocol {
    @inlinable public func hamiltonianPath<Algorithm: HamiltonianPathAlgorithm<Node, Edge>>(
        from source: Node,
        to destination: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findHamiltonianPath(from: source, to: destination, in: self)
    }

    @inlinable public func hamiltonianPath(
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? where Node: Hashable {
        hamiltonianPath(from: source, to: destination, using: .backtracking())
    }

    @inlinable public func hamiltonianPath<Algorithm: HamiltonianPathAlgorithm<Node, Edge>>(
        from source: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findHamiltonianPath(from: source, in: self)
    }

    @inlinable public func hamiltonianPath(
        from source: Node
    ) -> Path<Node, Edge>? where Node: Hashable {
        hamiltonianPath(from: source, using: .backtracking())
    }

    @inlinable public func hamiltonianCycle<Algorithm: HamiltonianPathAlgorithm<Node, Edge>>(
        from source: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findHamiltonianCycle(from: source, in: self)
    }

    @inlinable public func hamiltonianCycle(
        from source: Node
    ) -> Path<Node, Edge>? where Node: Hashable {
        hamiltonianCycle(from: source, using: .backtracking())
    }

    @inlinable public func hamiltonianPath<Algorithm: HamiltonianPathAlgorithm<Node, Edge>>(
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findHamiltonianPath(in: self)
    }

    @inlinable public func hamiltonianPath() -> Path<Node, Edge>? where Node: Hashable {
        hamiltonianPath(using: .backtracking())
    }

    @inlinable public func hamiltonianCycle<Algorithm: HamiltonianPathAlgorithm<Node, Edge>>(
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findHamiltonianCycle(in: self)
    }

    @inlinable public func hamiltonianCycle() -> Path<Node, Edge>? where Node: Hashable {
        hamiltonianCycle(using: .backtracking())
    }
}

public protocol HamiltonianPathAlgorithm<Node, Edge> {
    associatedtype Node: Hashable
    associatedtype Edge

    @inlinable func findHamiltonianPath(
        from source: Node,
        to destination: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findHamiltonianPath(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findHamiltonianPath(
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findHamiltonianCycle(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findHamiltonianCycle(
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?
}

extension HamiltonianPathAlgorithm {
    @inlinable public func findHamiltonianPath(in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        for source in graph.allNodes {
            if let path = findHamiltonianPath(from: source, in: graph) {
                return path
            }
        }
        return nil
    }

    @inlinable public func findHamiltonianCycle(in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        for startNode in graph.allNodes {
            if let cycle = findHamiltonianCycle(from: startNode, in: graph) {
                return cycle
            }
        }
        return nil
    }

    @inlinable public func findHamiltonianPath(from source: Node, in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        for destination in graph.allNodes where destination != source {
            if let path = findHamiltonianPath(from: source, to: destination, in: graph) {
                return path
            }
        }
        return nil
    }
}
