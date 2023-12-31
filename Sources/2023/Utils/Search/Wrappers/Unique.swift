struct UniqueVisitor<Base: SearchStrategy, HashValue: Hashable>: SearchStrategy {
    var base: Base
    var hashValue: (Base.Node) -> HashValue
    var visited: Set<HashValue> = []

    init(base: Base, hashValue: @escaping (Base.Node) -> HashValue) {
        self.base = base
        self.hashValue = hashValue
    }

    typealias Node = Base.Node

    mutating func add(_ node: Node) {
        base.add(node)
    }

    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Base.Node? {
        return base.next { node in
            defer { visited.insert(hashValue(node)) }
            return neighbors(node).filter { !visited.contains(hashValue($0)) }
        }
    }
}

extension SearchStrategy where Node: Hashable {
    func visitEachNodeOnlyOnce() -> UniqueVisitor<Self, Node> {
        UniqueVisitor(base: self) { $0 }
    }
}

extension SearchStrategy {
    func visitEachNodeOnlyOnce<HashValue: Hashable>(by hashValue: @escaping (Node) -> HashValue) -> UniqueVisitor<Self, HashValue> {
        UniqueVisitor(base: self, hashValue: hashValue)
    }
}
