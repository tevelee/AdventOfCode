public final class AoC_2022_Day8 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> Int {
        let grid = try parse()
        return visibility(of: grid).values.count { $0 }
    }

    public func solvePart2() throws -> Int {
        let grid = try parse()
        return grid.positions.map { visibilityScore(from: $0, in: grid) }.max() ?? 0
    }

    private func parse() throws -> [[Int]] {
        let lines = Array(try input.wholeInput.lines)
        return lines.map { line in
            Array(line).compactMap(\.wholeNumberValue)
        }
    }

    private func visibility(of grid: [[Int]]) -> [Position: Bool] {
        let rows = grid.firstRow...grid.lastRow
        let columns = grid.firstColumn...grid.lastColumn
        let top = columns.map { column in
            rows.map { grid[Position(row: $0, column: column)] }.visibilityArray
        }
        let bottom = columns.map { column in
            rows.reversed().map { grid[Position(row: $0, column: column)] }.visibilityArray
        }
        let left = rows.map { row in
            columns.map { grid[Position(row: row, column: $0)] }.visibilityArray
        }
        let right = rows.map { row in
            columns.reversed().map { grid[Position(row: row, column: $0)] }.visibilityArray
        }
        var result: [Position: Bool] = [:]
        for position in grid.positions {
            let isVisible = top[position.column][position.row]
                || bottom[position.column][grid.lastRow - position.row]
                || left[position.row][position.column]
                || right[position.row][grid.lastColumn - position.column]
            result[position] = isVisible
        }
        return result
    }

    private func visibilityScore(from position: Position, in grid: [[Int]]) -> Int {
        let top = (grid.firstRow...position.row).reversed()
            .map { grid[Position(row: $0, column: position.column)] }
            .visibilityScore
        let bottom = (position.row...grid.lastRow)
            .map { grid[Position(row: $0, column: position.column)] }
            .visibilityScore
        let left = (grid.firstColumn...position.column).reversed()
            .map { grid[Position(row: position.row, column: $0)] }
            .visibilityScore
        let right = (position.column...grid.lastColumn)
            .map { grid[Position(row: position.row, column: $0)] }
            .visibilityScore
        return top * bottom * left * right
    }
}

private struct Position: Hashable {
    var row: Int
    var column: Int
}

private extension Array where Element: Collection, Element.Index == Int {
    var positions: [Position]  {
        enumerated().flatMap { row, line in
            line.indices.map { Position(row: row, column: $0) }
        }
    }

    subscript<T>(position: Position) -> T where Element == [T] {
        get {
            self[position.row][position.column]
        }
        set {
            self[position.row][position.column] = newValue
        }
    }

    var firstRow: Int { 0 }
    var firstColumn: Int { 0 }
    var lastRow: Int { count - 1 }
    var lastColumn: Int { self[0].count - 1 }
}

private extension Array where Element == Int {
    var visibilityArray: [Bool] {
        reduce(into: (max: -1, values: [Bool]())) { result, value in
            result.values.append(value > result.max)
            result.max = Swift.max(result.max, value)
        }.values
    }

    var visibilityScore: Int {
        var copy = self
        let baseline = copy.removeFirst()

        var count = 0
        for height in copy {
            count += 1
            if height >= baseline {
                break
            }
        }
        return count
    }
}
