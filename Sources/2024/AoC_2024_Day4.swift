import Utils

public final class AoC_2024_Day4 {
    private let grid: Grid<Character>

    public init(_ input: Input) throws {
        grid = try Grid(input.wholeInput)
    }

    public func solvePart1() async throws -> Int {
        grid.count(consecutiveMatchesOf: "XMAS")
    }

    public func solvePart2() async throws -> Int {
        Grid("""
        M.S
        .A.
        M.S
        """, ignore: ["."]).allOrientations.sum(of: grid.countMatches)
    }
}

private struct Grid<Element: Equatable & CustomStringConvertible>: Equatable, CustomStringConvertible {
    private var elements: [Position: Element]

    private let numberOfRows: Int
    private let numberOfColumns: Int

    init(_ input: String, ignore: some Sequence<Character> = []) where Element == Character {
        self.init(rows: input.lines.map(Array.init), ignore: ignore)
    }

    init(rows: [[Element]], ignore: some Sequence<Element>) {
        numberOfRows = rows.count
        numberOfColumns = rows.first?.count ?? 0
        elements = rows.enumerated().reduce(into: [:]) { result, row in
            for column in row.element.enumerated() where !ignore.contains(column.element) {
                result[Position(row: row.offset, column: column.offset)] = column.element
            }
        }
    }

    private func isValid(position: Position) -> Bool {
        (0 ..< numberOfRows).contains(position.row) && (0 ..< numberOfColumns).contains(position.column)
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
        let pattern = Array(pattern)[...]
        var lines = validLines()
        lines += lines.map { $0.reversed() }
        return lines.sum { line in
            line.compactMap { elements[$0] }.windows(ofCount: pattern.count).count { $0 == pattern }
        }
    }

    private func validLines() -> [[Position]] {
        let horizontalPositions = (0 ..< numberOfRows).map { row in
            (0 ..< numberOfColumns).map { column in
                Position(row: row, column: column)
            }
        }
        let verticalPositions = (0 ..< numberOfColumns).map { column in
            (0 ..< numberOfRows).map { row in
                Position(row: row, column: column)
            }
        }
        let count = max(numberOfRows, numberOfColumns)
        let diagonal1Positions = (-numberOfRows ..< numberOfRows).map { start in
            (0 ... count).map { count in
                Position(row: start + count, column: count)
            }.filter(isValid)
        }
        let diagonal2Positions = (0 ..< 2 * numberOfRows).map { start in
            (0 ... count).map { count in
                Position(row: start - count, column: count)
            }.filter(isValid)
        }
        return horizontalPositions + verticalPositions + diagonal1Positions + diagonal2Positions
    }
}

// MARK: - Part 2

extension Grid {
    var allOrientations: some Sequence<Self> {
        var grid = self
        return (1...4).map { _ in
            grid.rotate()
            return grid
        }
    }

    private mutating func rotate() {
        elements = elements.mapKeys { position in
            Position(row: position.column, column: numberOfRows - 1 - position.row)
        }
    }

    func countMatches(of pattern: Grid<Element>) -> Int {
        windows(width: pattern.numberOfColumns, height: pattern.numberOfRows).count { window in
            window.matches(pattern: pattern)
        }
    }

    private func matches(pattern: Grid<Element>) -> Bool {
        pattern.elements.allSatisfy { elements[$0.key] == $0.value }
    }

    private func windows(width: Int, height: Int) -> some Sequence<Grid<Element>> {
        (0 ... numberOfRows - height).flatMap { startRow in
            (0 ... numberOfColumns - width).map { startColumn in
                let gridElements: [Position: Element] = (0 ..< height).reduce(into: [:]) { result, gridRow in
                    for gridColumn in 0 ..< width {
                        result[Position(row: gridRow, column: gridColumn)] = elements[Position(row: startRow + gridRow, column: startColumn + gridColumn)]
                    }
                }
                return Grid(elements: gridElements, numberOfRows: height, numberOfColumns: width)
            }
        }
    }

    private init(elements: [Position: Element], numberOfRows: Int, numberOfColumns: Int) {
        self.elements = elements
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
    }
}
