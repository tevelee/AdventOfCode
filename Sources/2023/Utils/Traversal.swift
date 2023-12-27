import Foundation

protocol Traversable<Node> {
    associatedtype Node
    associatedtype Next: Collection<Node>

    var start: Node { get }
    func neighbors(of node: Node) -> Next
}

protocol Terminable<Node> {
    associatedtype Node
    func goalReached(for node: Node) -> Bool
}


struct Traversal<Node, Next: Collection<Node>>: Traversable {
    let start: Node
    let next: (Node) -> Next

    init(start: Node, next: @escaping (Node) -> Next) {
        self.start = start
        self.next = next
    }

    func neighbors(of node: Node) -> Next {
        next(node)
    }
}

extension Traversal where Next == CollectionOfOne<Node> {
    init(start: Node, next: @escaping (Node) -> Node) {
        self.start = start
        self.next = { CollectionOfOne(next($0)) }
    }
}

extension Traversable {
    func includePath() -> WithPath<Self> {
        WithPath(base: self)
    }
    func avoidCycles<HashValue: Hashable>(of hashValue: @escaping (Node) -> HashValue) -> Acyclic<Self, HashValue> {
        Acyclic(base: self, hashValue: hashValue)
    }
    func avoidCycles() -> Acyclic<Self, Node> where Node: Hashable {
        Acyclic(base: self) { $0 }
    }
    func goal(_ goalReached: @escaping (Node) -> Bool) -> ConditionalTermination<Self> {
        ConditionalTermination(base: self, goalReached: goalReached)
    }
    func cost<Cost: Numeric>(_ cost: @escaping (Node, Node) -> Cost) -> WithCost<Self, Cost> {
        WithCost(base: self, cost: cost)
    }
    func distance<Distance: Numeric>(_ distance: @escaping (Node, Node) -> Distance) -> WithDistance<Self, Distance> {
        WithDistance(base: self, distance: distance)
    }
    func until(depth: Int) -> ConditionalTermination<WithDepth<Self>> {
        ConditionalTermination(base: WithDepth(base: self)) { $0.depth == depth }
    }
    func map<T>(_ transform: @escaping (Node) -> T) -> MappedTraversal<Self, T> {
        MappedTraversal(base: self, transform: transform)
    }
}

protocol TraversableWrapper: Traversable {
    associatedtype Node
    associatedtype Base: Traversable

    var base: Base { get }
    var extractBaseNode: (Node) -> Base.Node { get }
}

extension TraversableWrapper where Base: TraversableWrapper {
    func extractBaseNode(_ node: Base.Node) -> Base.Base.Node {
        base.extractBaseNode(node)
    }
}

extension TraversableWrapper where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: extractBaseNode(node))
    }
}

struct MappedTraversal<Base: Traversable, Element>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let transformed: Element
    }
    typealias Next = LazyMapCollection<Base.Next, Node>

    let base: Base
    let transform: (Base.Node) -> Element
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, transformed: transform(base.start))
    }

    func neighbors(of node: Node) -> Next {
        base.neighbors(of: node.node).lazy.map {
            Node(node: $0, transformed: transform($0))
        }
    }
}

extension MappedTraversal: Terminable where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: node.node)
    }
}

struct ConditionalTermination<Base: Traversable>: Traversable, Terminable, TraversableWrapper {
    typealias Node = Base.Node

    let base: Base
    let goalReached: (Node) -> Bool
    let extractBaseNode: (Node) -> Base.Node = \.self

    var start: Node {
        base.start
    }

    func neighbors(of node: Node) -> Base.Next {
        base.neighbors(of: node)
    }

    func goalReached(for node: Node) -> Bool {
        goalReached(node)
    }
}

struct WithDepth<Base: Traversable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let depth: Int
    }

    let base: Base
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, depth: 0)
    }

    func neighbors(of node: Node) -> LazyMapCollection<Base.Next, Node> {
        base.neighbors(of: node.node).lazy.map {
            Node(node: $0, depth: node.depth + 1)
        }
    }
}

struct WithPath<Base: Traversable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let path: [Base.Node]
    }
    typealias Next = LazyMapCollection<Base.Next, Node>

    let base: Base
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, path: [])
    }

    func neighbors(of node: Node) -> Next {
        base.neighbors(of: node.node).lazy.map {
            Node(node: $0, path: node.path + [$0])
        }
    }
}

struct WithCost<Base: Traversable, Cost: Numeric>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let cost: Cost
    }
    typealias Next = LazyMapCollection<Base.Next, Node>

    let base: Base
    let cost: (Base.Node, Base.Node) -> Cost
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, cost: .zero)
    }

    func neighbors(of node: Node) -> Next {
        base.neighbors(of: node.node).lazy.map {
            Node(node: $0, cost: cost(node.node, $0))
        }
    }
}

struct WithDistance<Base: Traversable, Distance: Numeric>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let distance: Distance
    }
    typealias Next = LazyMapCollection<Base.Next, Node>

    let base: Base
    let distance: (Base.Node, Base.Node) -> Distance
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, distance: .zero)
    }

    func neighbors(of node: Node) -> Next {
        base.neighbors(of: node.node).lazy.map {
            Node(node: $0, distance: distance(node.node, $0))
        }
    }
}

struct Acyclic<Base: Traversable, HashValue: Hashable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let visited: Set<HashValue>
    }
    typealias Next = LazyFilterCollection<LazyMapCollection<Base.Next, Node>>

    let base: Base
    let hashValue: (Base.Node) -> HashValue
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, visited: [])
    }

    func neighbors(of node: Node) -> Next {
        base.neighbors(of: node.node).lazy
            .map {
                Node(node: $0, visited: node.visited)
            }
            .filter {
                !node.visited.contains(hashValue($0.node))
            }
    }
}
