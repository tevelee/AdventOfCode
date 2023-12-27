import Foundation

struct Search<Node, Strategy: SearchStrategy<Node>, Traversal: Traversable<Node>> {
    let strategy: () -> Strategy
    let traversal: Traversal

    init(
        strategy: @escaping () -> Strategy,
        traversal: () -> Traversal
    ) {
        self.strategy = strategy
        self.traversal = traversal()
    }
}

extension Search: Sequence {
    struct Iterator: IteratorProtocol {
        let search: Search
        var storage: Strategy
        let traversal: Traversal

        init(search: Search, storage: Strategy, traversal: Traversal) {
            self.search = search
            self.storage = storage
            self.traversal = traversal

            self.storage.add(traversal.start)
        }

        mutating func next() -> Node? {
            storage.next(neighbors: traversal.neighbors)
        }
    }

    func makeIterator() -> Iterator {
        Iterator(search: self, storage: strategy(), traversal: traversal)
    }
}

extension Search where Traversal: Terminable {
    func run() -> Node? {
        first(where: traversal.goalReached)
    }

    func run() -> Traversal.Base.Node? where Traversal: TraversableWrapper {
        run().map(traversal.extractBaseNode)
    }

    func run() -> Traversal.Base.Base.Node? where Traversal: TraversableWrapper, Traversal.Base: TraversableWrapper {
        run().map(traversal.base.extractBaseNode)
    }
}

