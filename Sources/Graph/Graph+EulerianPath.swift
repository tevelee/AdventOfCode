extension FullGraphProtocol {
    @inlinable public func eulerianPath<Algorithm: EulerianPathAlgorithm<Node, Edge>>(
        from source: Node,
        to destination: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findEulerianPath(from: source, to: destination, in: self)
    }

    @inlinable public func eulerianPath(
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? where Node: Hashable, Edge: Hashable {
        eulerianPath(from: source, to: destination, using: .backtracking())
    }

    @inlinable public func eulerianPath<Algorithm: EulerianPathAlgorithm<Node, Edge>>(
        from source: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findEulerianPath(from: source, in: self)
    }

    @inlinable public func eulerianPath(
        from source: Node
    ) -> Path<Node, Edge>? where Node: Hashable, Edge: Hashable {
        eulerianPath(from: source, using: .backtracking())
    }

    @inlinable public func eulerianPath<Algorithm: EulerianPathAlgorithm<Node, Edge>>(
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findEulerianPath(in: self)
    }

    @inlinable public func eulerianPath() -> Path<Node, Edge>? where Node: Hashable, Edge: Hashable {
        eulerianPath(using: .backtracking())
    }

    @inlinable public func eulerianCycle<Algorithm: EulerianPathAlgorithm<Node, Edge>>(
        from source: Node,
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findEulerianCycle(from: source, in: self)
    }

    @inlinable public func eulerianCycle(
        from source: Node
    ) -> Path<Node, Edge>? where Node: Hashable, Edge: Hashable {
        eulerianCycle(from: source, using: .backtracking())
    }

    @inlinable public func eulerianCycle<Algorithm: EulerianPathAlgorithm<Node, Edge>>(
        using algorithm: Algorithm
    ) -> Path<Node, Edge>? {
        algorithm.findEulerianCycle(in: self)
    }

    @inlinable public func eulerianCycle() -> Path<Node, Edge>? where Node: Hashable, Edge: Hashable {
        eulerianCycle(using: .backtracking())
    }
}

public protocol EulerianPathAlgorithm<Node, Edge> {
    associatedtype Node: Hashable
    associatedtype Edge

    @inlinable func findEulerianPath(
        from source: Node,
        to destination: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findEulerianPath(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findEulerianPath(
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findEulerianCycle(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?

    @inlinable func findEulerianCycle(
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>?
}

extension EulerianPathAlgorithm {
    @inlinable public func findEulerianPath(in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        guard graph.hasEulerianPath() else {return nil }

        for source in graph.allNodes {
            if let path = findEulerianPath(from: source, in: graph) {
                return path
            }
        }
        return nil
    }

    @inlinable public func findEulerianCycle(in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        guard graph.hasEulerianCycle() else { return nil }

        for startNode in graph.allNodes {
            if let cycle = findEulerianCycle(from: startNode, in: graph) {
                return cycle
            }
        }
        return nil
    }

    @inlinable public func findEulerianPath(from source: Node, in graph: some FullGraphProtocol<Node, Edge>) -> Path<Node, Edge>? {
        guard graph.hasEulerianPath() else { return nil }

        for destination in graph.allNodes where destination != source {
            if let path = findEulerianPath(from: source, to: destination, in: graph) {
                return path
            }
        }
        return nil
    }
}
