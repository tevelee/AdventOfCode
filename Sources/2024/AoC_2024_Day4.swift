import Algorithms
import Utils

public final class AoC_2024_Day4 {
    private let grid: Grid<Character>

    public init(_ input: Input) throws {
        grid = try Grid(rows: input.wholeInput.lines.map(Array.init))
    }

    public func solvePart1() -> Int {
        grid.count(consecutiveMatchesOf: "XMAS")
    }

    public func solvePart2() -> Int {
        grid.count(diagonalMatchesOf: Array("MAS"))
    }
}

private struct Grid<Element: Equatable & CustomStringConvertible>: Equatable, CustomStringConvertible {
    private var elements: [Position: Element]

    private let numberOfRows: Int
    private let numberOfColumns: Int

    init(rows: [[Element]]) {
        numberOfRows = rows.count
        numberOfColumns = rows.first?.count ?? 0
        elements = rows.enumerated().reduce(into: [:]) { result, row in
            for column in row.element.enumerated() {
                result[Position(row: row.offset, column: column.offset)] = column.element
            }
        }
    }

    var description: String {
        (0 ..< numberOfRows).map { row in
            (0 ..< numberOfColumns).map { column in
                elements[Position(row: row, column: column)]?.description ?? "."
            }.joined()
        }.joined(separator: "\n")
    }
}

private struct Position: Hashable, CustomStringConvertible {
    var row, column: Int

    var description: String { "(\(column),\(row))" }
}

// MARK: - Part 1

extension Grid {
    func count(consecutiveMatchesOf pattern: some Collection<Element>) -> Int {
        allPositions.sum { position in
            Position.allDirections.count { direction in
                zip(pattern, 0...).allSatisfy { character, offset in
                    character == elements[position + direction * offset]
                }
            }
        }
    }

    private var allPositions: some Sequence<Position> {
        (0 ..< numberOfRows).lazy.flatMap { row in
            (0 ..< numberOfColumns).lazy.map { column in
                Position(row: row, column: column)
            }
        }
    }
}

extension Position {
    static var allDirections: some Sequence<Position> {
        (-1...1).lazy.flatMap { row in
            (-1...1).lazy.map { column in
                Position(row: row, column: column)
            }
            .filter { $0 != Position(row: 0, column: 0) }
        }
    }
}

private func * (position: Position, offset: Int) -> Position {
    Position(row: position.row * offset, column: position.column * offset)
}

private func + (lhs: Position, rhs: Position) -> Position {
    Position(row: lhs.row + rhs.row, column: lhs.column + rhs.column)
}

// MARK: - Part 2

extension Grid {
    func count(diagonalMatchesOf pattern: [Element]) -> Int {
        allPositions.filter { elements[$0] == pattern[1] }.sum { position in
            Position.diagonalDirectionPairs.count { direction1, direction2 in
                pattern[0] == elements[position + direction1] &&
                pattern[2] == elements[position + direction1.oppositeDirection] &&
                pattern[0] == elements[position + direction2] &&
                pattern[2] == elements[position + direction2.oppositeDirection]
            }
        }
    }
}

extension Position {
    static var diagonalDirectionPairs: some Sequence<(Position, Position)> {
        [-1, -1, 1, 1, -1, -1].adjacentPairs().map(Position.init).adjacentPairs()
    }

    var oppositeDirection: Position {
        self * -1
    }
}
