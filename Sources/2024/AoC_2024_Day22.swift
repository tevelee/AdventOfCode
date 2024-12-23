import Utils

public final class AoC_2024_Day22 {
    private let values: AnyAsyncSequence<Int>

    public init(_ input: Input) {
        values = input.lines.compactMap(Int.init).eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await values.sum {
            iterate($0).dropFirst(2000 - 1).first!
        }
    }

    public func solvePart2() async throws -> Int {
        var cache: [ArraySlice<Int>: [Int: Int]] = [:]
        for try await current in values {
            let values = iterate(current).prefix(2000).map { $0 % 10 }
            let windows = values.adjacentPairs().map { $1 - $0 }.windows(ofCount: 4)
            for (value, window) in zip(values.dropFirst(4), windows).reversed() {
                cache[window, default: [:]][current] = value
            }
        }
        return cache.maxValue { $0.value.values.sum() }!
    }

    private func iterate(_ original: Int) -> some Sequence<Int> {
        AnySequence {
            var value = original
            return AnyIterator {
                calculate(&value) { $0 * 64 }
                calculate(&value) { Int($0 / 32) }
                calculate(&value) { $0 * 2048 }
                return value
            }
        }
    }
}

private func calculate(_ value: inout Int, operation: (Int) -> Int) {
    value = (operation(value) ^ value) % 16777216
}
