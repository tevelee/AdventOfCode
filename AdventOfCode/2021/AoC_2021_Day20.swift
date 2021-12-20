import Foundation
import Algorithms

public final class AoC_2021_Day20 {
    private let lightPixelIndices: Set<Int>
    private let map: [[Int]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        let sections = input.paragraphs
        let rawMap = sections[0].reduce("", +)
        precondition(rawMap.count == 512)
        lightPixelIndices = Set(rawMap
            .enumerated()
            .filter { $0.element == "#" }
            .dictionary(byUniqueKey: \.offset)
            .keys)
        map = sections[1].map { line in
            line.map(Self.digit)
        }
    }

    @inlinable static func digit(character: Character) -> Int {
        character == "#" ? 1 : 0
    }

    public func solvePart1() async throws -> Int {
        iterate(2)
    }

    public func solvePart2() async throws -> Int {
        iterate(50)
    }

    private func iterate(_ count: Int) -> Int {
        var result = map
        for i in 0 ..< count {
            result = iterate(on: result, isFirstIteration: i == 0)
            //visualize(result)
        }
        return result.values.filter { $0 == 1 }.count
    }

    private func visualize(_ map: [[Int]]) {
        for line in map {
            print(String(line.map { $0 == 1 ? "#" : "." }))
        }
        print()
    }

    private func iterate(on map: [[Int]], isFirstIteration: Bool) -> [[Int]] {
        let outerValues = isFirstIteration ? 0 : map[0][0]
        let padded = padding(map: map, with: outerValues)
        var result = padded
        for position in padded.positions {
            let adjacent = product(-1 ... 1, -1 ... 1)
                .map { Position(row: position.row + $0, column: position.column + $1) }
                .map { padded[safe: $0] ?? outerValues }
            let index = binary(from: adjacent)
            result[position] = lightPixelIndices.contains(index) ? 1 : 0
        }
        return result
    }

    private func padding(map: [[Int]], with value: Int, amount padding: Int = 1) -> [[Int]] {
        map.padded(Array(repeating: value, count: map[0].count), leading: padding, trailing: padding)
            .map { $0.padded(value, leading: padding, trailing: padding) }
    }

    private func binary(from integers: [Int]) -> Int {
        integers.reduce(0) { result, item in
            result * 2 + item
        }
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

    var values: [Int] {
        flatMap { $0 }
    }

    subscript(position: Position) -> Int {
        get {
            self[position.row][position.column]
        }
        set {
            self[position.row][position.column] = newValue
        }
    }

    subscript(safe position: Position) -> Int? {
        self[safe: position.row]?[safe: position.column]
    }
}

private extension Array {
    func padded(_ element: Element, leading: Int, trailing: Int) -> [Element] {
        Array(repeating: element, count: leading)
        +
        self
        +
        Array(repeating: element, count: trailing)
    }
}
