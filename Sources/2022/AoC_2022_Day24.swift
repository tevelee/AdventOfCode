import Utils

public final class AoC_2022_Day24 {
    private let map: Map

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

        map = Map(blizzards: blizzards,
                  width: width,
                  height: height,
                  startPosition: startPosition,
                  endPosition: endPosition)
    }

    private lazy var pathFinder = AStar(map: map)
    private lazy var path = pathFinder.shortestPath(from: State(position: map.startPosition),
                                                    to: State(position: map.endPosition))

    public func solvePart1() -> Int {
        path.count
    }

    public func solvePart2() -> Int {
        let back = pathFinder.shortestPath(from: State(position: map.endPosition, numberOfMoves: path.count),
                                           to: State(position: map.startPosition))
        let forth = pathFinder.shortestPath(from: State(position: map.startPosition, numberOfMoves: path.count + back.count),
                                            to: State(position: map.endPosition))

        return path.count + back.count + forth.count
    }
}

private struct ParseError: Error {}

private struct Blizzard: Hashable {
    let startPosition: Position
    let direction: Direction

    func advanced(count: Int, on map: Map) -> Position {
        startPosition.apply { position in
            switch direction {
            case .up:
                position.row = nonNegativeModulo(of: position.row - count, by: map.height)
            case .down:
                position.row = nonNegativeModulo(of: position.row + count, by: map.height)
            case .left:
                position.column = nonNegativeModulo(of: position.column - count, by: map.width)
            case .right:
                position.column = nonNegativeModulo(of: position.column + count, by: map.width)
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

private struct Map {
    let blizzards: [Blizzard]
    let width: Int
    let height: Int
    let startPosition: Position
    let endPosition: Position

    @inlinable
    func hasBlizzard(at position: Position, afterNumberOfMoves count: Int) -> Bool {
        blizzards.contains { $0.advanced(count: count, on: self) == position }
    }

    @inlinable
    func possibleMoves(from state: State, goal: State) -> [Position] {
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
        if goal.position.distance(to: position) == 1, !result.contains(goal.position) {
            result.insert(goal.position, at: 0)
        }
        return result
    }

    private func isValid(position: Position) -> Bool {
        (0..<width).contains(position.column) && (0..<height).contains(position.row)
    }
}

extension Map: PathFinding {
    typealias Coordinate = State

    func neighbors(for state: State, goal: State) -> [State] {
        possibleMoves(from: state, goal: goal)
            .filter { !hasBlizzard(at: $0, afterNumberOfMoves: state.numberOfMoves + 1) }
            .map { State(position: $0, numberOfMoves: state.numberOfMoves + 1) }
    }

    func costToMove(from: State, to: State) -> Int {
        distance(from: from, to: to) + to.numberOfMoves
    }

    func distance(from: State, to: State) -> Int {
        from.position.distance(to: to.position)
    }

    func goalReached(at node: State, goal: State) -> Bool {
        node.position == goal.position
    }
}
