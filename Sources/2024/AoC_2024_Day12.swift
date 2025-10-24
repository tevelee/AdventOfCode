import Graphs
import Utils

public final class AoC_2024_Day12 {
    private let grid: Grid

    public init(_ input: Input) throws {
        grid = try Grid(fields: input.wholeInput.lines.map(Array.init))
    }

    public func solvePart1() -> Int {
        polygons.sum { $0.area * $0.perimeter }
    }

    public func solvePart2() -> Int {
        polygons.sum { $0.area * $0.numberOfSides }
    }

    private lazy var polygons: [GridPolygon] = {
        var remainingPositions = Set(grid.positions)
        var result: [GridPolygon] = []
        while let position = remainingPositions.first {
            let positions = itemsThatBelongToTheSameArea(position)
            result.append(GridPolygon(positions: Set(positions)))
            remainingPositions.subtract(positions)
        }
        return result
    }()

    private func itemsThatBelongToTheSameArea(_ position: Position) -> some Sequence<Position> {
        LazyIncidenceGraph(neighbors: grid.neighborsWithSameValue).traverse(from: position, using: .dfs()).vertices
    }
}

private struct Grid {
    let fields: [[Character]]
    private let numberOfRows: Int
    private let numberOfColumns: Int

    init(fields: [[Character]]) {
        numberOfRows = fields.count
        numberOfColumns = fields.first?.count ?? 0
        self.fields = fields
    }

    var positions: [Position] {
        fields.enumerated().flatMap { row, line in
            line.indices.map { Position(row: row, column: $0) }
        }
    }

    func neighbors(of position: Position) -> [Position] {
        [
            position.apply { $0.row += 1 },
            position.apply { $0.row -= 1 },
            position.apply { $0.column += 1 },
            position.apply { $0.column -= 1 }
        ].filter(contains)
    }

    func neighborsWithSameValue(of position: Position) -> [Position] {
        neighbors(of: position).filter { self[$0] == self[position] }
    }

    subscript(position: Position) -> Character {
        fields[position.row][position.column]
    }

    private func contains(position: Position) -> Bool {
        (0 ..< numberOfColumns).contains(position.column) && (0 ..< numberOfRows).contains(position.row)
    }
}

private struct Position: Hashable, CustomStringConvertible {
    var row, column: Int

    var description: String { "(\(column),\(row))" }

    func isNeighbor(of position: Position) -> Bool {
        switch (abs(column - position.column), abs(row - position.row)) {
            case (1, 0), (0, 1): true
            default: false
        }
    }

    var corners: [Position] {
        [
            self,
            apply { $0.row += 1 },
            apply { $0.column += 1 },
            apply {
                $0.row += 1
                $0.column += 1
            }
        ]
    }

    func apply(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

private struct GridPolygon {
    let positions: Set<Position>

    var area: Int {
        positions.count
    }

    var perimeter: Int {
        positions.sum { position in
            4 - positions.count(where: position.isNeighbor)
        }
    }

    var numberOfSides: Int {
        numberOfCorners
    }

    var numberOfCorners: Int {
        let corners = positions.flatMap(\.corners).grouped(by: \.self).mapValues(\.count)
        let uniqueCorners = corners.filter { !$0.value.isMultiple(of: 2) }.count
        let touchingCorners = corners.filter { $0.value == 2 }.count { corner, _ in
            let positions = corner.corners
                .map { Position(row: $0.row - 1, column: $0.column - 1) }
                .filter(positions.contains)
            let (p1, p2) = try! positions.elements()
            return !p1.isNeighbor(of: p2)
        }
        return uniqueCorners + touchingCorners * 2
    }
}
