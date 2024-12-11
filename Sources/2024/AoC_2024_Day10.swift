import Utils

public final class AoC_2024_Day10 {
    private let grid: [[Int]]
    private let positions: [Int: Set<Position>]

    public init(_ input: Input) throws {
        let grid: [[Int]] = try input.wholeInput.lines.map { Array($0).map { $0.wholeNumberValue ?? -1 } }
        var positions = grid.positions.grouped { grid[$0] }.mapValues { Set($0) }
        positions[-1] = nil
        self.grid = grid
        self.positions = positions
    }

    public func solvePart1() -> Int {
        var reachableTrailheads: [[Set<Position>]] = grid.map { $0.map { _ in [] } }
        for position in positions[9, default: []] {
            reachableTrailheads[position] = [position]
        }
        forEachTrail { position, trails in
            reachableTrailheads[position] = Set(trails.flatMap { reachableTrailheads[$0] })
        }
        return positions[0, default: []].sum { reachableTrailheads[$0].count }
    }

    public func solvePart2() -> Int {
        var numberOfDistinctTrails: [[Int]] = grid.map { $0.map { _ in 0 } }
        for position in positions[9, default: []] {
            numberOfDistinctTrails[position] = 1
        }
        forEachTrail { position, trails in
            numberOfDistinctTrails[position] = trails.sum { numberOfDistinctTrails[$0] }
        }
        return positions[0, default: []].sum { numberOfDistinctTrails[$0] }
    }

    private func forEachTrail(_ block: (Position, [Position]) -> Void) {
        for (height, positions) in positions.sorted(by: \.key, comparator: >).dropFirst() {
            for position in positions {
                block(position, grid.neighbors(of: position).filter { grid[$0] == height + 1 })
            }
        }
    }
}

private struct Position: Hashable, CustomStringConvertible {
    var x, y: Int

    func apply(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }

    var description: String { "(\(x),\(y))" }
}

private extension Array where Element: RandomAccessCollection, Element.Index == Int {
    var positions: [Position] {
        enumerated().flatMap { row, line in
            line.indices.map { Position(x: $0, y: row) }
        }
    }

    func neighbors(of position: Position) -> [Position] {
        [
            position.apply { $0.x += 1 },
            position.apply { $0.x -= 1 },
            position.apply { $0.y += 1 },
            position.apply { $0.y -= 1 }
        ].filter(contains)
    }

    private var width: Int { first?.endIndex ?? 0 }
    private var height: Int { endIndex }

    private func contains(position: Position) -> Bool {
        (0 ..< width).contains(position.x) && (0 ..< height).contains(position.y)
    }
}

private extension Array where Element: RandomAccessCollection & MutableCollection, Element.Index == Int {
    subscript(position: Position) -> Element.Element {
        get { self[position.y][position.x] }
        set { self[position.y][position.x] = newValue }
    }
}
