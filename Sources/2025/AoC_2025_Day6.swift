import Utils

public final class AoC_2025_Day6 {
    private let ops: [Character]
    private let numberLines: [String]

    public init(_ input: Input) throws {
        let lines = try Array(input.wholeInput.lines)
        guard let lastLine = lines.last else { throw ParseError() }
        self.ops = lastLine.split(separator: " ").compactMap(\.first)
        self.numberLines = lines.dropLast()
    }

    public func solvePart1() -> Int {
        let values = numberLines
            .map { $0.split(separator: " ")
            .compactMap { Int($0) } }
        let valuesGroupedByColumns = ops.indices.map { columnIndex in
            values.map { $0[columnIndex] }
        }
        return aggeregate(valuesGroupedByColumns)
    }

    public func solvePart2() -> Int {
        let values = numberLines[0].indices
            .map { columnIndex in
                numberLines.compactMap { $0[columnIndex].wholeNumberValue }
            }
            .split(separator: [])
            .map { columns in
                columns.map { digitsInColumn in
                    digitsInColumn.reduce(0) { $0 * 10 + $1 }
                }
            }
        return aggeregate(values)
    }
    
    private func aggeregate(_ values: [[Int]]) -> Int {
        zip(values, ops).sum { values, op in
            switch op {
                case "+": values.sum()
                case "*": values.product()
                default: 0
            }
        }
    }
}
