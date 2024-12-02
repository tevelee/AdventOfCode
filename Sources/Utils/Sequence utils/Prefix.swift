extension Collection where Element: Equatable {
    @inlinable public func hasPrefix(_ other: some Collection<Element>) -> Bool {
        if other.isEmpty {
            return true
        }
        guard first == other.first else {
            return false
        }
        return dropFirst().hasPrefix(other.dropFirst())
    }
}
