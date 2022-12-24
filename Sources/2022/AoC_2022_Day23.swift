import Utils

public final class AoC_2022_Day23 {
    private let elves: Set<Position>

    public init(_ input: Input) throws {
        let positions = try input.wholeInput.lines
            .enumerated()
            .flatMap { y, line in
                line.enumerated()
                    .filter { $1 == "#" }
                    .map { x, _ in Position(x: x, y: y) }
            }
        elves = Set(positions)
    }

    public func solvePart1() -> Int {
        solve(until: 1...10).size
    }

    public func solvePart2() -> Int {
        solve(until: 1...).count
    }

    private func solve(until range: some Sequence<Int>) -> (count: Int, size: Int) {
        var directions: [Direction] = [.north, .south, .west, .east]
        var positions = elves
        var count = 1
        for _ in range {
            // visualize(positions: positions)
            var proposalsInRound: [Position: Set<Position>] = [:]
            var hasValidProposal = false
            for position in positions {
                if position.positionsAround().contains(where: positions.contains) {
                    let chosenDirection = directions.first { direction in
                        !position.proposals(in: direction).contains(where: positions.contains)
                    }
                    let newPosition = chosenDirection.map { direction in
                        position.apply { $0.moveForward(in: direction) }
                    }
                    if let newPosition {
                        hasValidProposal = true
                        proposalsInRound[newPosition, default: []].insert(position)
                    } else {
                        proposalsInRound[position, default: []].insert(position)
                    }
                } else {
                    proposalsInRound[position, default: []].insert(position)
                }
            }
            if hasValidProposal {
                count += 1
            } else {
                break
            }
            var newPositions: Set<Position> = []
            for (proposedPosition, proposals) in proposalsInRound {
                if proposals.count == 1 {
                    newPositions.insert(proposedPosition)
                } else { // they stay
                    for originalPosition in proposals {
                        newPositions.insert(originalPosition)
                    }
                }
            }
            positions = newPositions

            let first = directions.removeFirst()
            directions.append(first)
        }
        let x = positions.map(\.x).minAndMax()!
        let y = positions.map(\.y).minAndMax()!
        let size = (x.max - x.min + 1) * (y.max - y.min + 1) - positions.count
        return (count, size)
    }

    private func visualize(positions: Set<Position>) {
        let y = positions.map(\.y).minAndMax()!
        let x = positions.map(\.x).minAndMax()!
        for y in (y.min - 2) ... (y.max + 2) {
            for x in (x.min - 2) ... (x.max + 2) {
                if positions.contains(Position(x: x, y: y)) {
                    print("#", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print()
        }
    }
}

private struct Position: Hashable {
    var x, y: Int

    func apply(_ block: (inout Position) -> Void) -> Position {
        var copy = self
        block(&copy)
        return copy
    }

    mutating func move(on axis: Axis, diff: Int) {
        switch axis {
        case .horizontal:
            x += diff
        case .vertical:
            y += diff
        }
    }

    mutating func moveForward(in direction: Direction) {
        move(on: direction.mainAxis, diff: direction.direction)
    }

    func proposals(in direction: Direction) -> some Sequence<Position> {
        (-1...1).lazy.map { diff in
            apply {
                $0.moveForward(in: direction)
                $0.move(on: direction.secondaryAxis, diff: diff)
            }
        }
    }

    func positionsAround() -> some Sequence<Position> {
        (-1...1).flatMap { y in
            (-1...1)
                .filter { x in !(x == 0 && y == 0) }
                .map { x in
                    apply {
                        $0.x += x
                        $0.y += y
                    }
                }
        }
    }
}

private enum Axis {
    case horizontal
    case vertical

    var perpendicular: Axis {
        switch self {
        case .horizontal: return .vertical
        case .vertical: return .horizontal
        }
    }
}

private enum Direction {
    case north
    case south
    case west
    case east

    var mainAxis: Axis {
        switch self {
        case .north, .south:
            return .vertical
        case .east, .west:
            return .horizontal
        }
    }

    var direction: Int {
        switch self {
        case .north, .west:
            return -1
        case .south, .east:
            return 1
        }
    }

    var secondaryAxis: Axis {
        mainAxis.perpendicular
    }
}
