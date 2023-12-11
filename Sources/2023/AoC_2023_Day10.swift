import Algorithms
import Collections

final class AoC_2023_Day10 {
    private let grid: PipeGrid
    private lazy var loop = grid.findLoopFromStartPosition()

    init(_ input: Input) throws {
        grid = try PipeGrid(rawString: input.wholeInput)
    }

    func solvePart1() -> Int {
        let (quotient, remainder) = loop.count.quotientAndRemainder(dividingBy: 2)
        return quotient + remainder
    }

    func solvePart2() -> Int {
        grid.positions2D.sum { row in
            row.lazy.chunked(on: loop.contains)
                .reduce(into: (isInside: false, count: 0)) { result, chunk in
                    let (isBoundary, positions) = chunk
                    if isBoundary {
                        if positions.count(where: grid.hasVerticalConnection).isOdd {
                            result.isInside.toggle()
                        }
                    } else if result.isInside {
                        result.count += positions.count
                    }
                }
                .count
        }
    }
}

private struct Grid<T> {
    private let values: [[T]]
    private let width, height: Int

    struct Position: Hashable {
        var x, y: Int

        func apply(_ block: (inout Position) -> Void) -> Position {
            var copy = self
            block(&copy)
            return copy
        }
    }

    enum Direction: CaseIterable {
        case up, left, down, right
    }

    init(values: [[T]]) {
        self.values = values
        self.height = values.count
        self.width = values[0].count
    }

    var positions: [Position] {
        positions2D.flatMap { $0 }
    }

    var positions2D: [[Position]] {
        (0..<height).map { y in
            (0..<width).map { x in
                Position(x: x, y: y)
            }
        }
    }

    func isValid(position: Position) -> Bool {
        (0..<width).contains(position.x) && (0..<height).contains(position.y)
    }

    func nextPosition(from position: Position, in direction: Direction) -> Position {
        switch direction {
        case .up: position.apply { $0.y -= 1 }
        case .down: position.apply { $0.y += 1 }
        case .left: position.apply { $0.x -= 1 }
        case .right: position.apply { $0.x += 1 }
        }
    }

    subscript(position: Position) -> T {
        values[position.y][position.x]
    }
}

@dynamicMemberLookup
private struct PipeGrid {
    typealias Position = Grid<Character>.Position
    typealias Direction = Grid<Character>.Direction

    private let grid: Grid<Character>
    private let startPosition: Position
    private var connections: [Position: Set<Position>] = [:]

    init(rawString: String) throws {
        let grid = Grid(values: Array(rawString.lines.map(Array.init)))
        guard let startPosition = grid.positions.first(where: { grid[$0] == "S" }) else { throw ParseError() }

        self.grid = grid
        self.startPosition = startPosition

        for position in grid.positions {
            for connectingPosition in availablePositions(from: position) where availablePositions(from: connectingPosition).contains(position) {
                connections[position, default: []].insert(connectingPosition)
            }
        }
    }

    func findLoopFromStartPosition() -> OrderedSet<Position> {
        var position = startPosition
        var visited: OrderedSet<Position> = []
        while let next = connections[position, default: []].first(where: { !visited.contains($0) }) {
            visited.append(next)
            position = next
        }
        return visited
    }

    private func availablePositions(from position: Position) -> Set<Position> {
        Set(
            directions(from: position)
                .map { grid.nextPosition(from: position, in: $0) }
                .filter(grid.isValid)
        )
    }

    private func directions(from position: Position) -> [Direction] {
        guard grid.isValid(position: position) else { return [] }
        return switch grid[position] {
        case "|": [.up, .down]
        case "-": [.left, .right]
        case "L": [.up, .right]
        case "J": [.up, .left]
        case "F": [.down, .right]
        case "7": [.down, .left]
        case "S": Direction.allCases
        default: []
        }
    }

    func hasVerticalConnection(_ position: Position) -> Bool {
        connections[position, default: []].contains(grid.nextPosition(from: position, in: .up))
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Grid<Character>, T>) -> T {
        grid[keyPath: keyPath]
    }
}

private extension Int {
    var isOdd: Bool { !isMultiple(of: 2) }
}
