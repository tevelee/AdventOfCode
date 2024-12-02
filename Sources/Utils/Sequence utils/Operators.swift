@inlinable public prefix func !<T>(keyPath: KeyPath<T, Bool> & Sendable) -> @Sendable (T) -> Bool {
    { !$0[keyPath: keyPath] }
}

@inlinable public func takeNewest<T>(old: T, new: T) -> T {
    new
}

@inlinable public func takeOldest<T>(old: T, new: T) -> T {
    old
}

@inlinable public func + <Key: Hashable, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    lhs.merging(rhs, uniquingKeysWith: takeNewest)
}

@inlinable public func + <Element>(lhs: [Element], rhs: Element) -> [Element] {
    lhs + [rhs]
}

@inlinable public func + <Element>(lhs: Element, rhs: [Element]) -> [Element] {
    [lhs] + rhs
}

@inlinable public func + <Element>(lhs: Set<Element>, rhs: Element) -> Set<Element> {
    lhs + [rhs]
}

@inlinable public func + <Element>(lhs: Set<Element>, rhs: some Collection<Element>) -> Set<Element> {
    lhs.union(rhs)
}

@inlinable public func += <Element>(lhs: inout Set<Element>, rhs: Element) {
    lhs += [rhs]
}
@inlinable public func += <Element>(lhs: inout Set<Element>, rhs: some Collection<Element>) {
    lhs.formUnion(rhs)
}
