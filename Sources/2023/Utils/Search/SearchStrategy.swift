import Foundation
import Collections

protocol SearchStrategy<Node> {
    associatedtype Node

    mutating func add(_ node: Node)
    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node?
}

protocol TraversalOrder {
    associatedtype Node
    func order(node: Node, neighbors: some Collection<Node>) -> [Node]
}

