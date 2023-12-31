import Utils

public final class AoC_2022_Day24 {
    private let startPosition, endPosition: Position
    private let width, height: Int
    private let blizzards: [Blizzard]

    public init(_ input: Input) throws {
        let lines = try input.wholeInput.lines
        guard let firstLine = lines.first,
            let startColumn = Array(firstLine).firstIndex(where: { $0 == "." }),
            let lastLine = lines.reversed().first,
            let endColumn = Array(lastLine).firstIndex(where: { $0 == "." })else {
            throw ParseError()
        }
        let width = firstLine.count - 2
        let height = lines.count - 2
        let startPosition = Position(row: -1, column: startColumn - 1)
        let endPosition = Position(row: height, column: endColumn - 1)

        var blizzards: [Blizzard] = []
        for (row, line) in lines.dropFirst().dropLast().enumerated() {
            for (column, character) in line.dropFirst().dropLast().enumerated() {
                if let direction = Direction(rawValue: character) {
                    let position = Position(row: row, column: column)
                    let blizzard = Blizzard(startPosition: position, direction: direction)
                    blizzards.append(blizzard)
                }
            }
        }
        (self.blizzards, self.width, self.height, self.startPosition, self.endPosition) = (blizzards, width, height, startPosition, endPosition)
    }

    private lazy var path = shortestPath(from: State(position: startPosition), to: State(position: endPosition))

    private func shortestPath(from source: State, to destination: State) -> Int {
        AStar {
            Traversal(start: source, neighbors: { state in
                self.possibleMoves(from: state, to: destination)
                    .filter { !self.hasBlizzard(at: $0, afterNumberOfMoves: state.numberOfMoves + 1) }
                    .map { State(position: $0, numberOfMoves: state.numberOfMoves + 1) }
            })
            .weight { edge in
                edge.source.position.distance(to: edge.destination.position) + edge.destination.numberOfMoves
            }
            .goal { state in
                state.position == destination.position
            }
        } heuristic: { state in
            state.position.distance(to: destination.position)
        }
        .shortestPath()
        .dropFirst()
        .count
    }

    public func solvePart1() -> Int {
        path
    }

    public func solvePart2() -> Int {
        let back = shortestPath(from: State(position: endPosition, numberOfMoves: path),
                                to: State(position: startPosition))
        let forth = shortestPath(from: State(position: startPosition, numberOfMoves: path + back),
                                 to: State(position: endPosition))

        return path + back + forth
    }

    private func hasBlizzard(at position: Position, afterNumberOfMoves count: Int) -> Bool {
        blizzards.contains { $0.advanced(count: count, width: width, height: height) == position }
    }

    private func possibleMoves(from state: State, to destination: State) -> [Position] {
        let position = state.position
        var result: [Position] = []
        if position.row < height - 1 {
            result.append(position.apply { $0.advance(in: .down) })
        }
        if position.column < width - 1 {
            result.append(position.apply { $0.advance(in: .right) })
        }
        if position.row > 0 {
            result.append(position.apply { $0.advance(in: .up) })
        }
        if position.column > 0 {
            result.append(position.apply { $0.advance(in: .left) })
        }
        result = result.filter(isValid)
        result.append(position) // wait in place
        if destination.position.distance(to: position) == 1, !result.contains(destination.position) {
            result.insert(destination.position, at: 0)
        }
        return result
    }

    private func isValid(position: Position) -> Bool {
        (0..<width).contains(position.column) && (0..<height).contains(position.row)
    }
}

private struct ParseError: Error {}

private struct Blizzard: Hashable {
    let startPosition: Position
    let direction: Direction

    func advanced(count: Int, width: Int, height: Int) -> Position {
        startPosition.apply { position in
            switch direction {
            case .up:
                position.row = nonNegativeModulo(of: position.row - count, by: height)
            case .down:
                position.row = nonNegativeModulo(of: position.row + count, by: height)
            case .left:
                position.column = nonNegativeModulo(of: position.column - count, by: width)
            case .right:
                position.column = nonNegativeModulo(of: position.column + count, by: width)
            }
        }
    }
}

private struct State: Hashable {
    let position: Position
    var numberOfMoves: Int = 0
}

private struct Position: Hashable, CustomStringConvertible {
    var row: Int
    var column: Int

    func apply(_ block: (inout Position) -> Void) -> Position {
        var copy = self
        block(&copy)
        return copy
    }

    func distance(to other: Position) -> Int {
        abs(other.row - row) + abs(other.column - column)
    }

    mutating func advance(in direction: Direction) {
        switch direction {
        case .up:
            row -= 1
        case .down:
            row += 1
        case .left:
            column -= 1
        case .right:
            column += 1
        }
    }

    var description: String { "(\(row),\(column))" }
}

private enum Direction: Character, CustomStringConvertible {
    case right = ">"
    case down = "v"
    case left = "<"
    case up = "^"

    var description: String { String(rawValue) }
}
