import Foundation
import Collections

protocol SearchStrategy<Node> {
    associatedtype Node

    mutating func add(_ node: Node)
    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node?
}

struct BFS<Node>: SearchStrategy {
    init() {}

    var queue: Deque<Node> = []

    mutating func add(_ node: Node) {
        queue.append(node)
    }

    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        guard let next = queue.popFirst() else { return nil }
        queue.append(contentsOf: neighbors(next))
        return next
    }
}

struct DFSNode<Node> {
    let node: Node
    var isFirstVisit: Bool
}

struct DFS<Node, Order: TraversalOrder>: SearchStrategy where Order.Node == DFSNode<Node> {
    var stack: [DFSNode<Node>] = []
    let order: Order

    init(order: Order = .preorder) where Self == DFS<Node, PreorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }

    init(order: Order) where Self == DFS<Node, PostorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }

    mutating func add(_ node: Node) {
        stack.append(DFSNode(node: node, isFirstVisit: true))
    }

    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        while var node = stack.popLast() {
            if node.isFirstVisit {
                node.isFirstVisit.toggle()
                let neighbors = neighbors(node.node).map {
                    DFSNode(node: $0, isFirstVisit: true)
                }
                stack = order.order(node: node, neighbors: neighbors) + stack
                continue
            }
            return node.node
        }
        return nil
    }
}

protocol TraversalOrder {
    associatedtype Node
    func order(node: Node, neighbors: some Collection<Node>) -> [Node]
}

extension TraversalOrder {
    static var preorder: PreorderTraversalOrder<Node> {
        PreorderTraversalOrder()
    }
    static var postorder: PostorderTraversalOrder<Node> {
        PostorderTraversalOrder()
    }
}

struct PreorderTraversalOrder<Node>: TraversalOrder {
    func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        [node] + neighbors
    }
}

struct PostorderTraversalOrder<Node>: TraversalOrder {
    func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        neighbors + [node]
    }
}

protocol BinaryTreeNodeProtocol {
    var lhs: Self? { get }
    var rhs: Self? { get }
}

enum BinaryTreeNode<T>: BinaryTreeNodeProtocol {
    indirect case composite(value: T, lhs: BinaryTreeNode<T>?, rhs: BinaryTreeNode<T>?)

    init(value: T, lhs: BinaryTreeNode<T>? = nil, rhs: BinaryTreeNode<T>? = nil) {
        self = .composite(value: value, lhs: lhs, rhs: rhs)
    }

    var value: T {
        switch self {
        case .composite(let value, _, _): value
        }
    }

    var lhs: BinaryTreeNode<T>? {
        switch self {
        case .composite(_, let lhs, _): return lhs
        }
    }

    var rhs: BinaryTreeNode<T>? {
        switch self {
        case .composite(_, _, let rhs): return rhs
        }
    }
}

extension TraversalOrder where Node: BinaryTreeNodeProtocol {
    static var inorder: InorderTraversalOrder<Node> {
        InorderTraversalOrder()
    }
}

struct InorderTraversalOrder<Node: BinaryTreeNodeProtocol>: TraversalOrder {
    func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        switch (node.lhs, node.rhs) {
        case (nil, nil):
            return [node]
        case (.some(let lhs), nil):
            return [lhs, node]
        case (nil, .some(let rhs)):
            return [node, rhs]
        case (.some(let lhs), .some(let rhs)):
            return [lhs, node, rhs]
        }
    }
}

extension DFSNode: BinaryTreeNodeProtocol where Node: BinaryTreeNodeProtocol {
    var lhs: Self? {
        node.lhs.map {
            DFSNode(node: $0, isFirstVisit: isFirstVisit)
        }
    }
    var rhs: Self? {
        node.rhs.map {
            DFSNode(node: $0, isFirstVisit: isFirstVisit)
        }
    }
}

extension DFS where Node: BinaryTreeNodeProtocol {
    init(order: Order) where Self == DFS<Node, InorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }
}

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
