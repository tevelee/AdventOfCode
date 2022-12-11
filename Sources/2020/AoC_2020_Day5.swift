
public final class AoC_2020_Day5 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        var highest = 0
        for try await seatID in seats().map({ $0.row * 8 + $0.column }) {
            if seatID > highest {
                highest = seatID
            }
        }
        return highest
    }

    public func solvePart2() async throws -> Int {
        let seats = try await seats().collect().map { $0.row * 8 + $0.column }.sorted()
        for (one, two) in seats.adjacentPairs() {
            if two - one > 1 {
                return one + 1
            }
        }
        return 0
    }

    public func seats() -> AsyncMapSequence<AsyncLineSequence<URL.AsyncBytes>, (row: Int, column: Int)> {
        inputFileURL.lines.map { line -> (row: Int, column: Int) in
            let index = (line.index(line.startIndex, offsetBy: 6))
            let rowSelector = line[...index]
            let row = Self.select(rowSelector, lower: "F", upper: "B")
            let columnSelector = line[index...].dropFirst(1)
            let column = Self.select(columnSelector, lower: "L", upper: "R")
            return (row, column)
        }
    }

    private static func select(_ rowSelector: Substring, lower: Character, upper: Character) -> Int {
        let bound = pow(rowSelector.count) - 1
        var range = 0 ... bound
        for character in rowSelector {
            let half = range.lowerBound + Int((range.upperBound - range.lowerBound) / 2)
            range = character == lower ? range.lowerBound ... half : half ... range.upperBound
        }
        return range.upperBound
    }
}
