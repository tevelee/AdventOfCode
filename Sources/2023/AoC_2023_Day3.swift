final class AoC_2023_Day3 {
    let board: [[Character]]

    init(_ input: Input) throws {
        board = try input.wholeInput.lines.map { Array($0) }
    }

    private lazy var numbers: [some Collection<Position>] = board.indices.flatMap { y in
        board[y].indices
            .map { x in Position(x: x, y: y) }
            .split(omittingEmptySubsequences: true) { !board[$0].isWholeNumber }
    }

    func solvePart1() -> Int {
        numbers
            .filter { neighbors(of: $0).contains(where: isSymbol) }
            .sum(of: value)
    }

    func solvePart2() -> Int {
        board.positions
            .filter { board[$0] == "*" }
            .compactMap { gearPosition in
                let positionsAroundGear = neighbors(of: [gearPosition])
                let numbersAroundGear = numbers.filter(positionsAroundGear.isIntersecting)
                return if numbersAroundGear.count == 2 {
                    numbersAroundGear.product(of: value)
                } else {
                    nil
                }
            }
            .sum()
    }

    private func value(of positions: some Collection<Position>) -> Int {
        positions.compactMap { board[$0].wholeNumberValue }.reduce(0) { $0 * 10 + $1 }
    }

    private func neighbors(of positions: some Collection<Position>) -> Set<Position> {
        var result: Set<Position> = []
        for position in positions {
            result.formUnion((position.y - 1 ... position.y + 1).flatMap { y in
                (position.x - 1 ... position.x + 1).map { x in
                    Position(x: x, y: y)
                }
            })
        }
        return result.subtracting(positions).filter(isValid)
    }

    private func isSymbol(at position: Position) -> Bool {
        let character = board[position]
        return character != "." && !character.isWholeNumber
    }

    private func isValid(position: Position) -> Bool {
        board.indices.contains(position.y) && board[position.y].indices.contains(position.x)
    }
}

private struct Position: Hashable {
    let x, y: Int
}

private extension [[Character]] {
    subscript(position: Position) -> Character {
        get {
            self[position.y][position.x]
        }
        set {
            self[position.y][position.x] = newValue
        }
    }

    var positions: [Position] {
        enumerated().flatMap { row, line in
            line.indices.map { Position(x: $0, y: row) }
        }
    }
}

private extension Set<Position> {
    func isIntersecting(with positions: some Collection<Position>) -> Bool {
        !Set(positions).isDisjoint(with: self)
    }
}
