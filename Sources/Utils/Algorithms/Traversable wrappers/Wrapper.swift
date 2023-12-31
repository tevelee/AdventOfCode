public protocol TraversableWrapper: Traversable {
    associatedtype Base: Traversable

    var base: Base { get }
    var extractBaseNode: (Node) -> Base.Node { get }
}

extension TraversableWrapper where Base: TraversableWrapper {
    @inlinable public var extractBaseNode: (Base.Node) -> Base.Base.Node {
        {
            base.extractBaseNode($0)
        }
    }
}
