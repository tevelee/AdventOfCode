import Algorithms

final class AoC_2023_Day18 {
    private let entries: [Entry]

    init(_ input: Input) throws {
        entries = try input.wholeInput.lines.compactMap { line in
            guard let output = line.firstMatch(of: /(?<direction>\w) (?<length>\d+) \(\#(?<color>.*?)\)/)?.output,
                  let direction = output.direction.first.flatMap(Direction.init),
                  let length = Int(output.length) else {
                return nil
            }
            return Entry(direction: direction, length: length, color: String(output.color))
        }
    }

    func solvePart1() -> Int {
        solve(entries.map { Move(direction: $0.direction, length: $0.length) })
    }

    func solvePart2() -> Int {
        solve(entries.map { Move(hex: $0.color) })
    }

    private func solve(_ moves: [Move]) -> Int {
        sizeOfLagoon(path: path(moves: moves), length: moves.sum(of: \.length))
    }

    private func path(
        from startingPosition: Position = Position(x: 0, y: 0),
        moves: [Move]
    ) -> [Position] {
        var current = startingPosition
        var positions: [Position] = [startingPosition]
        for move in moves {
            current.perform(move)
            positions.append(current)
        }
        return positions
    }

    private func sizeOfLagoon(path: [Position], length: Int) -> Int {
        area(of: path.map { ($0.x, $0.y) }) + length / 2 + 1
    }
}

private struct Move {
    let direction: Direction
    let length: Int
}

extension Move {
    init(hex: String) {
        var characters = hex
        let direction = Direction.from(hexDigit: characters.removeLast())
        let length = characters.compactMap(\.hexDigitValue).reduce(0) { $0 * 16 + $1 }
        self.init(direction: direction, length: length)
    }
}

private struct Entry {
    let direction: Direction
    let length: Int
    let color: String
}

private enum Direction: Character {
    case up = "U"
    case left = "L"
    case down = "D"
    case right = "R"

    static func from(hexDigit: Character) -> Direction {
        switch hexDigit {
        case "0": .right
        case "1": .down
        case "2": .left
        case "3": .up
        default: fatalError()
        }
    }
}

private struct Position: Hashable {
    var x, y: Int

    mutating func perform(_ move: Move) {
        let length = move.length
        switch move.direction {
        case .up: y += length
        case .left: x -= length
        case .down: y -= length
        case .right: x += length
        }
    }
}
