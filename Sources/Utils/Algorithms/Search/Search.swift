import Foundation

public struct Search<Node, Strategy: SearchStrategy<Node>, Traversal: Traversable<Node>> {
    public let strategy: () -> Strategy
    public let traversal: Traversal

    @inlinable public init(
        strategy: @escaping () -> Strategy,
        traversal: () -> Traversal
    ) {
        self.strategy = strategy
        self.traversal = traversal()
    }
}

extension Search: Sequence {
    public struct Iterator: IteratorProtocol {
        public let search: Search
        public var storage: Strategy
        public let traversal: Traversal

        @inlinable public init(search: Search, storage: Strategy, traversal: Traversal) {
            self.search = search
            self.storage = storage
            self.traversal = traversal

            self.storage.add(traversal.start)
        }

        @inlinable public mutating func next() -> Node? {
            storage.next { [traversal] node in
                traversal.edges(from: node).map(\.destination)
            }
        }
    }

    @inlinable public func makeIterator() -> Iterator {
        Iterator(search: self, storage: strategy(), traversal: traversal)
    }
}

extension Search where Traversal: Terminable {
    @inlinable public func run() -> Node? {
        first(where: traversal.goalReached)
    }

    @inlinable public func run() -> Traversal.Base.Node? where Traversal: TraversableWrapper {
        run().map(traversal.extractBaseNode)
    }

    @inlinable public func run() -> Traversal.Base.Base.Node? where Traversal: TraversableWrapper, Traversal.Base: TraversableWrapper {
        run().map(traversal.base.extractBaseNode)
    }
}
