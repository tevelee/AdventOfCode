extension Sequence {
    @inlinable public func elements() throws -> (Element, Element) {
        let result: Void = ()
        var iterator = makeIterator()
        guard let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value) else { throw ParseError() }
        return result
    }

    @inlinable public func elements() throws -> (Element, Element, Element) {
        let result: Void = ()
        var iterator = makeIterator()
        guard let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value) else { throw ParseError() }
        return result
    }

    @inlinable public func elements() throws -> (Element, Element, Element, Element) {
        let result: Void = ()
        var iterator = makeIterator()
        guard let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value),
              let value = iterator.next(), case let result = join(result, value) else { throw ParseError() }
        return result
    }

//    @inlinable public func values<each T>(type: (repeat (each T).Type) = (repeat (each T).self)) throws -> (repeat each T) /*where repeat each T == Element*/ { // same-type requirement will only be supported in Swift 6.1+
//        var result: Any = ()
//        var iterator = makeIterator()
//        for _ in repeat each type {
//            guard let value = iterator.next() else { throw ParseError() }
//            result = join(result, value)
//        }
//        return result /*as! (repeat each T)*/
//    }
}

@usableFromInline func join<Prefix>(_ value: Void, _ prefix: Prefix) -> (Prefix) {
    prefix
}

@usableFromInline func join<each T, Suffix>(_ value: (repeat each T), _ suffix: Suffix) -> (repeat each T, Suffix) {
    (repeat each value, suffix)
}

@_disfavoredOverload
@usableFromInline func join<Prefix, each T>(_ prefix: Prefix, _ value: (repeat each T)) -> (Prefix, repeat each T) {
    (prefix, repeat each value)
}

extension StringProtocol where Self.SubSequence == Substring {
    public func split(_ separator: String, maxSplits: Int = .max, omittingEmptySubsequences: Bool = true) -> [String] {
        split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }
}
