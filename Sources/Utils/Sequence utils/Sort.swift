extension Collection {
    @inlinable public func sorted<T>(by selector: (Element) -> T) -> [Element] where T: Comparable {
        sorted(by: selector, comparator: <)
    }

    @inlinable public func sorted<T>(by selector: (Element) -> T, comparator: (T, T) -> Bool) -> [Element] where T: Comparable {
        sorted { comparator(selector($0), selector($1)) }
    }
}
