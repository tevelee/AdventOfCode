import Foundation
import Collections

@inlinable public func search<T>(
    start: T,
    using strategy: () -> some SearchStrategy<T>,
    goal: (T) -> Bool,
    next: (T) -> some Sequence<T>
) -> T? {
    var storage = strategy()
    return search(storage: &storage, start: start, next: next, goal: goal)
}

// overload for a single next value
@inlinable public func search<T>(
    start: T,
    using strategy: () -> some SearchStrategy<T>,
    goal: (T) -> Bool,
    next: (T) -> T
) -> T? {
    search(start: start, using: strategy, goal: goal) { [next($0)] }
}

@usableFromInline func search<T>(
    storage: inout some SearchStrategy<T>,
    start: T,
    next: (T) -> some Sequence<T>,
    goal: (T) -> Bool
) -> T? {
    storage.add(start)
    while let current = storage.next() {
        if goal(current) {
            return current
        }
        for value in next(current) where !storage.shouldDiscard(value) {
            storage.add(value)
        }
    }
    return nil
}

// MARK: Strategies

public protocol SearchStrategy<Node> {
    associatedtype Node

    mutating func add(_ node: Node)
    mutating func next() -> Node?
    func shouldDiscard(_ node: Node) -> Bool
}

extension SearchStrategy {
    public func shouldDiscard(_ node: Node) -> Bool { false }
}

public struct BFS<Node>: SearchStrategy {
    @inlinable public init() {}

    @usableFromInline var queue: Deque<Node> = []

    @inlinable public mutating func add(_ node: Node) {
        queue.append(node)
    }

    @inlinable public mutating func next() -> Node? {
        queue.popFirst()
    }
}

public struct DFS<Node>: SearchStrategy {
    @inlinable public init() {}

    @usableFromInline var stack: [Node] = []

    @inlinable public mutating func add(_ node: Node) {
        stack.append(node)
    }

    @inlinable public mutating func next() -> Node? {
        stack.popLast()
    }
}

public struct Unique<Base, Element, HashValue: Hashable> {
    @usableFromInline var base: Base
    @usableFromInline var hashValue: (Element) -> HashValue
    @usableFromInline var visited: Set<HashValue> = []

    @inlinable public init(base: Base, hashValue: @escaping (Element) -> HashValue) {
        self.base = base
        self.hashValue = hashValue
    }
}

extension Unique: SearchStrategy where Base: SearchStrategy, Element == Base.Node {
    public typealias Node = Base.Node

    @inlinable public mutating func add(_ node: Node) {
        base.add(node)
        visited.insert(hashValue(node))
    }

    @inlinable public mutating func next() -> Node? {
        base.next()
    }

    @inlinable public func shouldDiscard(_ node: Node) -> Bool {
        visited.contains(hashValue(node)) || base.shouldDiscard(node)
    }
}

extension SearchStrategy where Node: Hashable {
    @inlinable public var unique: Unique<Self, Node, Node> {
        Unique(base: self) { $0 }
    }
}

extension SearchStrategy {
    @inlinable public func unique<HashValue: Hashable>(by hashValue: @escaping (Node) -> HashValue) -> Unique<Self, Node, HashValue> {
        Unique(base: self, hashValue: hashValue)
    }
}
