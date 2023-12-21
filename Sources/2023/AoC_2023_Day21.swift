import Algorithms

final class AoC_2023_Day21 {
    private let startPosition: Position
    private let map: [[Character]]

    init(_ input: Input) throws {
        let map: [[Character]] = try input.wholeInput.lines.map(Array.init)
        guard let startPosition = map.positions.first(where: { map[$0] == "S" }) else { throw ParseError() }
        self.map = map
        self.startPosition = startPosition
    }

    func solvePart1(steps: Int) -> Int {
        var availablePositions: Set<Position> = [startPosition]
        for _ in 1...steps {
            availablePositions = Set(availablePositions.flatMap { position in
                map.neighbors(of: position)
                    .filter(map.contains)
                    .filter {  map[$0] != "#" }
            })
        }
        return availablePositions.count
    }

    func solvePart2(steps: Int) -> Int {
        var availablePositions: Set<Position> = [startPosition]
        for _ in 1...steps {
            availablePositions = Set(availablePositions.flatMap { position in
                map.neighbors(of: position).filter {  map[infinite: $0] != "#" }
            })
        }
        return availablePositions.count
    }
}

private struct Position: Hashable, CustomStringConvertible {
    let row: Int
    let column: Int

    var description: String { "(\(row),\(column))" }
}

private extension Array where Element: Collection, Element.Index == Int {
    var positions: some Sequence<Position> {
        self.lazy.enumerated().flatMap { row, line in
            line.indices.lazy.map { Position(row: row, column: $0) }
        }
    }

    subscript(position: Position) -> Element.Element {
        self[position.row][position.column]
    }

    subscript(infinite position: Position) -> Element.Element {
        let row = nonNegativeModulo(of: position.row, by: count)
        let column = nonNegativeModulo(of: position.column, by: self[row].count)
        return self[row][column]
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
        ]
    }

    func contains(position: Position) -> Bool {
        indices.contains(position.row) && self[position.row].indices.contains(position.column)
    }
}
