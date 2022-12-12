public final class AoC_2022_Day12 {
    private let grid: [[Int]]
    private let start: Position
    private let end: Position

    public init(_ input: Input) throws {
        (grid, start, end) = try Self.parse(input: input)
    }

    public func solvePart1() -> Int? {
        shortestPaths[start]
    }

    public func solvePart2() -> Int? {
        grid.positions
            .filter { grid[$0] == Character("a").intValue }
            .compactMap { shortestPaths[$0] }
            .min()
    }

    private lazy var shortestPaths: [Position: Int] = {
        var cache: [Position: Int] = [end: 0]
        exploreShortestPaths(from: end, on: grid, cache: &cache)
        return cache
    }()

    private func exploreShortestPaths(from start: Position,
                                      on grid: [[Int]],
                                      cache: inout [Position: Int]) {
        let current = cache[start]! + 1
        for position in grid.neighbors(of: start) where grid[start] - grid[position] <= 1 {
            if cache[position].map({ current < $0 }) ?? true {
                cache[position] = current
                exploreShortestPaths(from: position, on: grid, cache: &cache)
            }
        }
    }

    private static func parse(input: Input) throws -> (grid: [[Int]], start: Position, end: Position) {
        var start: Position?
        var end: Position?

        let grid = try input.wholeInput.lines.enumerated().map { row, line in
            line.enumerated().map { column, character in
                let position = Position(row: row, column: column)
                switch character {
                case "S":
                    start = position
                    return Character("a").intValue
                case "E":
                    end = position
                    return Character("z").intValue
                default:
                    return character.intValue
                }
            }
        }

        guard let start, let end else {
            throw ParseError()
        }

        return (grid, start, end)
    }

    private func visualize() {
        for values in grid {
            for value in values {
                print(Unicode.Scalar(value)!, terminator: "")
            }
            print()
        }

        print()

        var cache: [Position: [Position]] = [end: []]
        paths(from: end, on: grid, cache: &cache)
        let path = [start] + cache[start]!
        for (row, values) in grid.enumerated() {
            for column in values.indices {
                let position = Position(row: row, column: column)
                if position == end {
                    print("E", terminator: "")
                } else if let index = path.firstIndex(of: position) {
                    let from = path[index]
                    let to = path[index + 1]
                    switch (to.row - from.row, to.column - from.column) {
                    case (1, 0): print("v", terminator: "")
                    case (-1, 0): print("^", terminator: "")
                    case (0, 1): print(">", terminator: "")
                    case (0, -1): print("<", terminator: "")
                    default: fatalError()
                    }
                } else {
                    print(".", terminator: "")
                }
            }
            print()
        }

        func paths(from start: Position, on grid: [[Int]], cache: inout [Position: [Position]]) {
            let current = [start] + cache[start]!
            for position in grid.neighbors(of: start) where grid[start] - grid[position] <= 1 {
                if cache[position].map({ current.count < $0.count }) ?? true {
                    cache[position] = current
                    paths(from: position, on: grid, cache: &cache)
                }
            }
        }
    }
}

private struct ParseError: Error {}

private extension Character {
    var intValue: Int {
        unicodeScalars.first.map {  Int($0.value) } ?? 0
    }
}

private struct Position: Hashable, CustomStringConvertible {
    let row: Int
    let column: Int

    var description: String { "(\(row),\(column))" }
}

private extension Array where Element: Collection, Element.Index == Int {
    var positions: [Position] {
        enumerated().flatMap { row, line in
            line.indices.map { Position(row: row, column: $0) }
        }
    }

    subscript(position: Position) -> Element.Element {
        self[position.row][position.column]
    }

    subscript(safe position: Position) -> Element.Element? {
        self[safe: position.row]?[safe: position.column]
    }

    func neighbors(of position: Position) -> some Sequence<Position> {
        [
            Position(row: position.row, column: position.column + 1),
            Position(row: position.row, column: position.column - 1),
            Position(row: position.row + 1, column: position.column),
            Position(row: position.row - 1, column: position.column)
        ].filter { self[safe: $0] != nil }
    }
}
