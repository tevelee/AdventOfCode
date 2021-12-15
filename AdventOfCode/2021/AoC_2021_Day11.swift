import Algorithms
import Foundation

public final class AoC_2021_Day11 {
    let levels: [[Int]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        levels = contents.lines.map { line in
            line.compactMap(\.wholeNumberValue)
        }
    }

    public func solvePart1() -> Int {
        iterations { $0.count == 100 }.numberOfFlashes
    }

    public func solvePart2() -> Int {
        iterations(until: allZero).numberOfIterations
    }

    private func allZero(_ iteration: Iteration) -> Bool {
        iteration.levels.flatMap { $0 }.allSatisfy { $0 == 0 }
    }

    public typealias Iteration = (count: Int, levels: [[Int]])

    public func iterations(until condition: (Iteration) -> Bool) -> (numberOfIterations: Int, numberOfFlashes: Int, levels: String) {
        var levels = levels
        var numberOfFlashes = 0
        var numberOfIterations = 0
        while !condition((numberOfIterations, levels)) {
            numberOfFlashes += iterate(on: &levels, positions: levels.positions)
            numberOfIterations += 1
        }
        return (numberOfIterations,
                numberOfFlashes,
                levels.map { $0.map(String.init).joined(separator: "") }.joined(separator: "\n"))
    }

    private func iterate(on levels: inout [[Int]],
                         positions: [Position],
                         skip: [Position] = []) -> Int {
        for position in positions {
            if levels[position] == 0, !skip.isEmpty { continue }
            levels[position] += 1
        }
        var numberOfFlashes = 0
        for p in positions where !skip.contains(p) && levels[p] > 9 {
            numberOfFlashes += iterate(on: &levels,
                                       positions: adjacentPositions(for: p, in: levels),
                                       skip: skip + [p]) + 1
            levels[p] = 0

        }
        return numberOfFlashes
    }

    private func adjacentPositions(for position: Position, in levels: [[Int]]) -> [Position] {
        product(position.row.range(padding: 1).clamped(to: levels.fullRange),
                position.column.range(padding: 1).clamped(to: levels[0].fullRange))
            .map(Position.init)
    }
}

extension BidirectionalCollection {
    var fullRange: ClosedRange<Index> {
        startIndex ... index(before: endIndex)
    }
}

extension Int {
    func range(padding: Int) -> ClosedRange<Int> {
        self - padding ... self + padding
    }
}

private struct Position: Equatable {
    let row: Int
    let column: Int
}

private extension Array where Element == [Int] {
    var positions: [Position] {
        enumerated().flatMap { row, line in
            line.indices.map { Position(row: row, column: $0) }
        }
    }

    subscript(position: Position) -> Int {
        get {
            self[position.row][position.column]
        }
        set {
            self[position.row][position.column] = newValue
        }
    }
}
