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
