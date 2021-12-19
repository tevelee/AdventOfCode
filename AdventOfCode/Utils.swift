import Foundation

extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
    { !$0[keyPath: keyPath] }
}

extension String {
    subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Substring {
    subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    func sorted<T>(by selector: (Element) -> T) -> [Element] where T: Comparable {
        sorted(by: selector, comparator: <)
    }

    func sorted<T>(by selector: (Element) -> T, comparator: (T, T) -> Bool) -> [Element] where T: Comparable {
        sorted { comparator(selector($0), selector($1)) }
    }

    var headAndTail: (head: Element, tail: SubSequence)? {
        guard let head = first else { return nil }
        return (head, dropFirst())
    }
}

extension Sequence {
    var headAndTail: (head: Element, tail: IteratorSequence<Iterator>)? {
        var iterator = makeIterator()
        guard let head = iterator.next() else { return nil }
        let tail = IteratorSequence(iterator)
        return (head, tail)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
