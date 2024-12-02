extension Dictionary where Value: Hashable {
    @inlinable public var flipped: [Value: Key] {
        Dictionary<Value, [Key]>(grouping: keys, by: { self[$0]! }).compactMapValues(\.first)
    }
}

extension Dictionary {
    @inlinable public func mapKeys<NewKey: Hashable>(_ transform: (Key) -> NewKey, uniquingKeysWith: (Value, Value) -> Value = takeNewest) -> [NewKey: Value] {
        Dictionary<NewKey, Value>(map { (transform($0.key), $0.value) }, uniquingKeysWith: uniquingKeysWith)
    }
}
