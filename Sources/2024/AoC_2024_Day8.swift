import Utils

public final class AoC_2024_Day8 {
    private let width: Int
    private let height: Int
    private let antennas: [Character: Set<Position>]

    public init(_ input: Input) throws {
        let lines = try input.wholeInput.lines
        width = lines.count
        height = lines.first?.count ?? 0

        var antennas: [Character: Set<Position>] = [:]
        for (row, line) in lines.enumerated() {
            for (column, character) in line.enumerated() where ![".", "#"].contains(character) {
                antennas[character, default: []].insert(Position(x: column, y: row))
            }
        }
        self.antennas = antennas
    }

    public func solvePart1() throws -> Int {
        try solve(maxAntinodesInEachDirection: 1)
    }

    public func solvePart2() throws -> Int {
        try solve(includeAntennas: true)
    }

    private func solve(maxAntinodesInEachDirection max: Int = .max, includeAntennas: Bool = false) throws -> Int {
        let results = try antennas.values.flatMap { positions in
            try positions.combinations(ofCount: 2).flatMap { pair in
                let (first, second) = try pair.elements()
                let diff = Position(x: second.x - first.x, y: second.y - first.y)
                let antinodes1 = antinodes { first - diff * $0 }.prefix(max)
                let antinodes2 = antinodes { second + diff * $0 }.prefix(max)
                let antennas = includeAntennas ? [first, second] : []
                return antinodes1 + antinodes2 + antennas
            }
        }
        return Set(results).count(where: isWithinBounds)
    }

    private func antinodes(calculate: @escaping (Int) -> Position) -> some Sequence<Position> {
        (1...).lazy.map(calculate).prefix(while: isWithinBounds)
    }

    private func isWithinBounds(_ position: Position) -> Bool {
        (0 ..< width).contains(position.x) && (0 ..< height).contains(position.y)
    }
}

private struct Position: Hashable {
    let x, y: Int
}

private func * (lhs: Position, rhs: Int) -> Position {
    Position(x: lhs.x * rhs, y: lhs.y * rhs)
}

private func + (lhs: Position, rhs: Position) -> Position {
    Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

private func - (lhs: Position, rhs: Position) -> Position {
    Position(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
