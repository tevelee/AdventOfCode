extension Collection where Index == Int {
    @inlinable public func elements() throws -> (Element, Element) {
        guard count == 2 else { throw ParseError() }
        return (self[0], self[1])
    }

    @inlinable public func elements() throws -> (Element, Element, Element) {
        guard count == 3 else { throw ParseError() }
        return (self[0], self[1], self[2])
    }

    @inlinable public func elements() throws -> (Element, Element, Element, Element) {
        guard count == 4 else { throw ParseError() }
        return (self[0], self[1], self[2], self[3])
    }
}

extension StringProtocol where Self.SubSequence == Substring {
    public func split(_ separator: String, maxSplits: Int = .max, omittingEmptySubsequences: Bool = true) -> [String] {
        split(separator: separator, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences).map(String.init)
    }
}
