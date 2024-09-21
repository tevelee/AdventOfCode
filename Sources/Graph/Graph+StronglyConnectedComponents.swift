extension FullGraphProtocol {
    @inlinable public func findStronglyConnectedComponents<Algorithm: StronglyConnectedComponentsAlgorithm<Node, Edge>>(
        using algorithm: Algorithm
    ) -> [[Node]] {
        algorithm.findStronglyConnectedComponents(in: self)
    }
}

public protocol StronglyConnectedComponentsAlgorithm<Node, Edge> {
    associatedtype Node: Hashable
    associatedtype Edge

    func findStronglyConnectedComponents(in graph: some FullGraphProtocol<Node, Edge>) -> [[Node]]
}
