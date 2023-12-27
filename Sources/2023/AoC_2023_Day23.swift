import Utils

final class AoC_2023_Day23 {
    private let grid: [[Character]]
    private let start, end: Position

    init(_ input: Input) throws {
        let grid: [[Character]] = try input.wholeInput.lines.map(Array.init)
        guard let start = grid.positions.first(where: { grid[$0] == "." }),
              let end = grid.positions.reversed().first(where: { grid[$0] == "." }) else { throw ParseError() }
        self.grid = grid
        self.start = start
        self.end = end
    }

    func solvePart1() -> Int {
        solve { [grid] position in
            var next: [Position] = []
            let right = Position(row: position.row, column: position.column + 1)
            if grid[safe: right] == "." || grid[safe: right] == ">" {
                next.append(right)
            }
            let left = Position(row: position.row, column: position.column - 1)
            if grid[safe: left] == "." || grid[safe: left] == "<" {
                next.append(left)
            }
            let up = Position(row: position.row - 1, column: position.column)
            if grid[safe: up] == "." || grid[safe: up] == "^" {
                next.append(up)
            }
            let down = Position(row: position.row + 1, column: position.column)
            if grid[safe: down] == "." || grid[safe: down] == "v" {
                next.append(down)
            }
            return next
        }
    }

    func solvePart2() -> Int {
        longestPath(from: start, to: end, seen: [start], paths: paths(between: junctions()))
    }

    private func longestPath(
        from start: Position,
        to end: Position,
        seen: Set<Position>,
        paths: [Position: [(Position, length: Int)]]
    ) -> Int {
        if start == end {
            return 0
        }
        var longest = 0
        for (point, length) in paths[start]! {
            if seen.contains(point) { continue }
            let best = longestPath(from: point, to: end, seen: seen + point, paths: paths)
            longest = max(longest, best + length)
        }
        return longest
    }

    private func junctions() -> Set<Position> {
        var junctions = [start, end]
        for position in grid.positions {
            guard grid[position] == "." else { continue }
            let numberOfSlopes = grid.neighbors(of: position).count { grid[$0] != "#" && grid[$0] != "." }
            if numberOfSlopes > 1 {
                junctions.append(position)
            }
        }
        return Set(junctions)
    }

    private func paths(between junctions: Set<Position>) -> [Position: [(Position, length: Int)]] {
        var paths: [Position: [(Position, Int)]] = [:]
        for junction in junctions.sorted() {
            for neighbor in grid.neighbors(of: junction).filter({ grid[$0] != "#" }) {
                var current = neighbor
                var path: Set<Position> = [junction]
                repeat {
                    path.insert(current)
                    let next = grid.neighbors(of: current).filter { grid[$0] != "#" && !path.contains($0) }
                    if next.isEmpty { continue }
                    current = next[0]
                } while !junctions.contains(current)
                paths[junction, default: []].append((current, path.count))
            }
        }
        return paths
    }

    private func solve(_ neighbors: @escaping (Position) -> [Position]) -> Int {
        Search {
            DFS()
        } traversal: {
            Traversal(start: start, next: neighbors)
                .includePath()
        }
        .reduce(into: 0) { result, element in
            if element.node == end {
                result = max(result, element.path.count)
            }
        }
    }
}

private struct Position: Hashable {
    let row, column: Int
}

extension Position: CustomStringConvertible {
    public var description: String {
        "\(column),\(row)"
    }
}

extension Position: Comparable {
    public static func < (lhs: Position, rhs: Position) -> Bool {
        if lhs.row == rhs.row {
            lhs.column < rhs.column
        } else {
            lhs.row < rhs.row
        }
    }
}

private extension Array where Element: Collection, Element.Index == Int {
    var positions: some Collection<Position> {
        self.lazy.enumerated().flatMap { row, line in
            line.indices.lazy.map { Position(row: row, column: $0) }
        }
    }

    subscript(position: Position) -> Element.Element {
        self[position.row][position.column]
    }

    subscript(safe position: Position) -> Element.Element? {
        self[safe: position.row]?[safe: position.column]
    }

    func contains(position: Position) -> Bool {
        indices.contains(position.row) && self[position.row].indices.contains(position.column)
    }

    func neighbors(of position: Position) -> some Sequence<Position> {
        [
            Position(row: position.row, column: position.column + 1),
            Position(row: position.row - 1, column: position.column),
            Position(row: position.row, column: position.column - 1),
            Position(row: position.row + 1, column: position.column)
        ].filter(contains)
    }
}
