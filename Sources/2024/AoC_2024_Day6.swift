import Utils

public final class AoC_2024_Day6 {
    private let map: Map
    private let guardStartPosition: Position

    public init(_ input: Input) throws {
        let lines = try input.wholeInput.lines
        var obstacles: Set<Position> = []
        var guardStartPosition: Position?
        for (row, line) in lines.enumerated() {
            for (column, character) in line.enumerated() {
                let position = Position(x: column, y: row)
                switch character {
                    case "#": obstacles.insert(position)
                    case "^": guardStartPosition = position
                    default: break
                }
            }
        }
        guard let guardStartPosition else { throw ParseError() }
        self.map = Map(width: lines.first?.count ?? 0, height: lines.count, obstacles: obstacles)
        self.guardStartPosition = guardStartPosition
    }

    private lazy var patrol: Set<Position> = {
        guard case .finite(let positions) = runPatrol(on: map) else { return [] }
        return positions
    }()

    public func solvePart1() async throws -> Int {
        patrol.count
    }

    public func solvePart2() async throws -> Int {
        patrol.filter { $0 != guardStartPosition }.count {
            runPatrol(on: map.withObstacle(at: $0)) == .circular
        }
    }

    private func runPatrol(on map: Map) -> Patrol {
        map.runPatrol(at: guardStartPosition, heading: .up)
    }
}

private struct Map {
    let width: Int
    let height: Int
    private(set) var obstacles: Set<Position>

    private struct State: Hashable {
        var position: Position
        var direction: Direction

        mutating func advance() {
            position.move(in: direction)
        }
    }

    func runPatrol(at position: Position, heading direction: Direction) -> Patrol {
        var currentState = State(position: position, direction: direction)
        var visited: Set<State> = []
        repeat {
            guard visited.insert(currentState).inserted else { return .circular }
            if willHitObstacle(at: currentState) {
                currentState.direction.turnRight()
            } else {
                currentState.advance()
            }
        } while isValidPosition(currentState.position)
        return .finite(Set(visited.map(\.position)))
    }

    private func isValidPosition(_ position: Position) -> Bool {
        (0 ..< width).contains(position.x) && (0 ..< height).contains(position.y)
    }

    private func willHitObstacle(at state: State) -> Bool {
        var state = state
        state.advance()
        return obstacles.contains(state.position)
    }

    func withObstacle(at position: Position) -> Map {
        var copy = self
        copy.obstacles.insert(position)
        return copy
    }
}

private enum Patrol: Equatable {
    case circular
    case finite(Set<Position>)
}

private struct Position: Hashable {
    private(set) var x, y: Int

    mutating func move(in direction: Direction) {
        switch direction {
            case .up: y -= 1
            case .down: y += 1
            case .left: x -= 1
            case .right: x += 1
        }
    }
}

private enum Direction: Int {
    case up, right, down, left

    mutating func turnRight() {
        self = Direction(rawValue: rawValue + 1) ?? .up
    }
}
