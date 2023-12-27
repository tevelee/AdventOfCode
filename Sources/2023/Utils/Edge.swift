import Foundation

struct Edge<Node> {
    var source: Node
    var destination: Node

    init(source: Node, destination: Node) {
        self.source = source
        self.destination = destination
    }

    private var attachments: [ObjectIdentifier: Any] = [:]

    subscript<Key: EdgeAttachmentKey>(key: Key.Type) -> Key.Value {
        get {
            return attachments[ObjectIdentifier(key)] as? Key.Value ?? key.defaultValue
        }
        set {
            attachments[ObjectIdentifier(key)] = newValue
        }
    }

    func map<Result>(_ transform: (Node) -> Result) -> Edge<Result> {
        Edge<Result>(
            source: transform(source),
            destination: transform(destination)
        )
    }
}

protocol EdgeAttachmentKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

struct Weight<Value: Numeric>: EdgeAttachmentKey {
    static var defaultValue: Value { .zero }
}

extension Edge {
    func withWeight(_ weight: some Numeric) -> Edge {
        var edge = self
        edge[Weight.self] = weight
        return edge
    }
}

struct Heuristic<Value: Numeric>: EdgeAttachmentKey {
    static var defaultValue: Value { .zero }
}

extension Edge {
    func withHeuristic(_ heuristic: some Numeric) -> Edge {
        var edge = self
        edge[Heuristic.self] = heuristic
        return edge
    }
}
