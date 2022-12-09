import Algorithms
import Utils

public final class AoC_2021_Day1 {
    let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ input: String) {
        lines = input.lines.async.eraseToAnyAsyncSequence()
    }

    public func solvePart1_functional() async throws -> Int {
        try await lines
            .compactMap { Int($0) }
            .collect()
            .adjacentPairs()
            .filter { $0 < $1 }
            .count
    }

    public func solvePart1_lazy() async throws -> Int {
        struct Iteration {
            var count = 0
            var previous: Int?
        }
        return try await lines
            .compactMap { Int($0) }
            .reduce(into: Iteration()) { result, current in
                if let previous = result.previous, current > previous {
                    result.count += 1
                }
                result.previous = current
            }
            .count
    }

    public func solvePart1_imperative() async throws -> Int {
        var previous: Int?
        var count = 0
        for try await current in lines.compactMap({ Int($0) }) {
            if let previous = previous, current > previous {
                count += 1
            }
            previous = current
        }
        return count
    }

    public func solvePart2_imperative() async throws -> Int {
        var count = 0

        var previous: Int?
        let lines = try await lines.compactMap({ Int($0) }).collect()

        for i in 2 ..< lines.count {
            let current = lines[i-2] + lines[i-1] + lines[i]
            if let previous = previous, current > previous {
                count += 1
            }
            previous = current
        }
        return count
    }

    public func solvePart2_lazy() async throws -> Int {
        var count = 0

        var previous1: Int?
        var previous2: Int?
        var previousSum: Int?
        for try await current in lines.compactMap({ Int($0) }) {
            guard let prev1 = previous1 else {
                previous1 = current
                continue
            }
            guard let prev2 = previous2 else {
                previous2 = current
                continue
            }

            let currentSum = current + prev1 + prev2
            if let prevSum = previousSum, currentSum > prevSum {
                count += 1
            }

            previous2 = previous1
            previous1 = current
            previousSum = currentSum
        }
        return count
    }

    public func solvePart2_functional() async throws -> Int {
        struct Iteration {
            var previousSum: Int?
            var count = 0
            var previous1: Int?
            var previous2: Int?
        }
        return try await lines
            .compactMap { Int($0) }
            .reduce(into: Iteration()) { result, current in
                guard let previous2 = result.previous2 else {
                    result.previous2 = current
                    return
                }
                guard let previous1 = result.previous1 else {
                    result.previous1 = current
                    return
                }
                let sum = current + previous1 + previous2
                if let previousSum = result.previousSum, sum > previousSum {
                    result.count += 1
                }
                result.previousSum = sum
                result.previous2 = previous1
                result.previous1 = current
            }
            .count
    }
}

private extension AsyncSequence {
    func enumerated() -> EnumeratedAsyncSequence<Self> {
        EnumeratedAsyncSequence(base: self)
    }
}

struct EnumeratedAsyncSequence<Base: AsyncSequence>: AsyncSequence {
    typealias AsyncIterator = Iterator<Base.AsyncIterator>
    typealias Element = AsyncIterator.Element

    let base: Base

    func makeAsyncIterator() -> Iterator<Base.AsyncIterator> {
        Iterator(base: base.makeAsyncIterator())
    }

    struct Iterator<Base: AsyncIteratorProtocol>: AsyncIteratorProtocol {
        typealias Element = (offset: Int, element: Base.Element)

        var base: Base
        var offset = 0

        mutating func next() async throws -> (offset: Int, element: Base.Element)? {
            guard let element = try await base.next() else { return nil }
            defer { offset += 1 }
            return (offset: offset, element: element)
        }
    }
}
