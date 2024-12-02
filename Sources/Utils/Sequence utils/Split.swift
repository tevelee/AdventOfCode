import AsyncAlgorithms

extension AsyncSequence where Element: Equatable & Sendable {
    @inlinable public func split(by element: Element) -> some AsyncSequence<[Element], any Error> {
        chunked(into: Array.self, on: { $0 != element }).filter(\.0).map(\.1)
    }
}
