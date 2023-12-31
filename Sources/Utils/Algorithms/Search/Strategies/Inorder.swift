extension TraversalOrder where Node: BinaryTreeNodeProtocol {
    @inlinable public static var inorder: InorderTraversalOrder<Node> {
        InorderTraversalOrder()
    }
}

public struct InorderTraversalOrder<Node: BinaryTreeNodeProtocol>: TraversalOrder {
    @inlinable public init() {}

    @inlinable public func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
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

extension DFS where Node: BinaryTreeNodeProtocol {
    @inlinable public init(order: Order) where Self == DFS<Node, InorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }
}

extension DFSNode: BinaryTreeNodeProtocol where Node: BinaryTreeNodeProtocol {
    @inlinable public var lhs: Self? {
        node.lhs.map {
            DFSNode(node: $0, isFirstVisit: isFirstVisit)
        }
    }
    @inlinable public var rhs: Self? {
        node.rhs.map {
            DFSNode(node: $0, isFirstVisit: isFirstVisit)
        }
    }
}

public protocol BinaryTreeNodeProtocol {
    var lhs: Self? { get }
    var rhs: Self? { get }
}

public enum BinaryTreeNode<T>: BinaryTreeNodeProtocol {
    indirect case composite(value: T, lhs: BinaryTreeNode<T>?, rhs: BinaryTreeNode<T>?)

    @inlinable public init(value: T, lhs: BinaryTreeNode<T>? = nil, rhs: BinaryTreeNode<T>? = nil) {
        self = .composite(value: value, lhs: lhs, rhs: rhs)
    }

    @inlinable public var value: T {
        switch self {
        case .composite(let value, _, _): value
        }
    }

    @inlinable public var lhs: BinaryTreeNode<T>? {
        switch self {
        case .composite(_, let lhs, _): return lhs
        }
    }

    @inlinable public var rhs: BinaryTreeNode<T>? {
        switch self {
        case .composite(_, _, let rhs): return rhs
        }
    }
}
