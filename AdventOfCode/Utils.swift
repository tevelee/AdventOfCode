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
}
