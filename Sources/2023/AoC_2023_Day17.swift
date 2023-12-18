import Utils

final class AoC_2023_Day17 {
    private let grid: [[Int]]
    private let topLeft, bottomRight: Position

    init(_ input: Input) throws {
        grid = try input.wholeInput.lines.map { Array($0).compactMap(\.wholeNumberValue) }
        guard let first = grid.positions().first, let last = grid.positions().reversed().first else { throw ParseError() }
        topLeft = first
        bottomRight = last
    }

    func solvePart1() -> Int {
        solve(range: 0...3)
    }

    func solvePart2() -> Int {
        solve(range: 4...10)
    }

    private func solve(range: ClosedRange<Int>) -> Int {
        AStar(map: Map(grid: grid, range: range))
            .shortestPath(from: .init(topLeft), to: .init(bottomRight))
            .sum { grid[$0.position] }
    }
}

private struct Map: PathFinding {
    private let grid: [[Int]]
    private let range: ClosedRange<Int>

    init(grid: [[Int]], range: ClosedRange<Int>) {
        self.grid = grid
        self.range = range
    }

    func neighbors(for state: State, goal: State) -> [State] {
        Direction.allCases.compactMap { direction in
            if let existingDirection = state.direction, existingDirection != direction, state.length < range.lowerBound {
                return nil
            }
            if state.direction == direction, state.length == range.upperBound {
                return nil
            }
            if state.direction == direction.opposite {
                return nil
            }

            var position = state.position
            position.move(in: direction)
            guard isValid(position) else { return nil }

            let length = direction == state.direction ? state.length : 0
            return State(
                position: position,
                direction: direction,
                length: length + 1
            )
        }
    }

    func costToMove(from origin: State, to destination: State) -> Int {
        grid[destination.position]
    }

    func distance(from origin: State, to destination: State) -> Int {
        1
    }

    func goalReached(at current: State, goal: State) -> Bool {
        current.position == goal.position && current.length >= range.lowerBound
    }

    private func isValid(_ position: Position) -> Bool {
        grid.indices.contains(position.y) && grid[position.y].indices.contains(position.x)
    }
}

private struct State: Hashable {
    let position: Position
    let direction: Direction?
    let length: Int
}

extension State {
    init(_ position: Position) {
        self.position = position
        self.direction = nil
        self.length = 0
    }
}

private struct Position: Hashable {
    var x, y: Int

    mutating func move(in direction: Direction) {
        switch direction {
        case .up: y -= 1
        case .left: x -= 1
        case .down: y += 1
        case .right: x += 1
        }
    }
}

private enum Direction: CaseIterable {
    case up, left, down, right

    var opposite: Direction {
        switch self {
        case .up: .down
        case .left: .right
        case .down: .up
        case .right: .left
        }
    }
}

private extension Array where Element: Collection, Element.Index == Int {
    subscript(position: Position) -> Element.Element {
        self[position.y][position.x]
    }

    func positions() -> some Collection<Position> {
        self.lazy.enumerated().flatMap { y, line in
            line.indices.lazy.map { Position(x: $0, y: y) }
        }
    }
}
