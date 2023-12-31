import Algorithms
import Utils

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
        availablePositions(for: steps, isFinite: true)
    }

    func solvePart2(steps: Int) -> Int {
        let size = map.count
        let (quotient, remainder) = steps.quotientAndRemainder(dividingBy: size)
        return if quotient / 100 == 2023 {
            Int(predictValueInQuadraticEquation(for: Double(quotient), given: [0, 1, 2].map { x in
                (
                    x: Double(x),
                    y: Double(availablePositions(for: remainder + size * x, isFinite: false))
                )
            }))
        } else {
            availablePositions(for: steps, isFinite: false)
        }
    }

    private func availablePositions(for steps: Int, isFinite: Bool) -> Int {
        if isFinite {
            availablePositions(for: steps) { [map] in map.contains(position: $0) && map[$0] != "#" }
        } else {
            availablePositions(for: steps) { [map] in map[infinite: $0] != "#" }
        }
    }

    private func availablePositions(for steps: Int, where condition: @escaping (Position) -> Bool) -> Int {
        Search {
            BFS().visitEachNodeOnlyOnce(by: \.node)
        } traversal: {
            Traversal(start: [startPosition]) { [map] node in
                Set(node.flatMap(map.neighbors).filter(condition))
            }
            .until(depth: steps)
        }.run()?.count ?? 0
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
