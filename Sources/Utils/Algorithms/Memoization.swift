@inlinable public func memoize<In: Hashable, Out>(_ factory: @escaping (In) -> Out) -> (In) -> Out {
    var memo: [In: Out] = [:]
    return {
        if let result = memo[$0] {
            return result
        } else {
            let result = factory($0)
            memo[$0] = result
            return result
        }
    }
}

@inlinable public func memoize<each In: Hashable, Out>(_ factory: @escaping (repeat each In) -> Out) -> (repeat each In) -> Out {
    var memo: [Container<repeat each In>: Out] = [:]
    return { (pack: repeat each In) -> Out in
        let container = Container(repeat each pack)
        if let result = memo[container] {
            return result
        } else {
            let result = factory(repeat each pack)
            memo[container] = result
            return result
        }
    }
}

@usableFromInline struct Container<each T> {
    @usableFromInline let value: (repeat each T)

    @inlinable init(_ value: repeat each T) {
        self.value = (repeat each value)
    }
}

extension Container: Equatable where repeat each T: Equatable {
    @inlinable static func == (lhs: Container<repeat each T>, rhs: Container<repeat each T>) -> Bool {
        for (left, right) in repeat (each lhs.value, each rhs.value) {
            guard left == right else { return false }
        }
        return true
    }
}

extension Container: Hashable where repeat each T: Hashable {
    @inlinable func hash(into hasher: inout Hasher) {
        for element in repeat each value {
            hasher.combine(element)
        }
    }
}
