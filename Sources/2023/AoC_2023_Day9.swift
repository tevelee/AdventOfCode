import Algorithms

final class AoC_2023_Day9: Day {
    private let entries: AnyAsyncSequence<[Int]>

    init(_ input: Input) {
        entries = input.lines.map(\.integers).eraseToAnyAsyncSequence()
    }

    func solvePart1() async throws -> Int {
        try await entries.sum(of: extrapolateNext)
    }

    func solvePart2() async throws -> Int {
        try await entries.map { $0.reversed() }.sum(of: extrapolateNext)
    }

    private func extrapolateNext(in input: some Sequence<Int>) -> Int {
        var extrapolatedValue = 0
        var values = input.reversed().eraseToAnySequence()
        repeat {
            extrapolatedValue += values.first ?? 0
            values = values.adjacentPairs().map { $0 - $1 }.eraseToAnySequence()
        } while !values.allSatisfy { $0 == 0 }
        return extrapolatedValue
    }
}

private extension Sequence {
    var first: Element? {
        first { _ in true }
    }

    func eraseToAnySequence() -> AnySequence<Element> {
        AnySequence(self)
    }
}
