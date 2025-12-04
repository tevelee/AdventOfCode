import Utils

public final class AoC_2025_Day4 {
    private let grid: Set<Position>
    private let width: Int
    private let height: Int

    public init(_ input: Input) throws {
        let lines = try input.wholeInput.lines
        let positions = lines.enumerated().flatMap { y, line in
            line.enumerated().compactMap { x, character -> Position? in
                guard character == "@" else { return nil }
                return Position(x: x, y: y)
            }
        }
        grid = Set(positions)
        guard let firstLine = lines.first else { throw ParseError("empty row") }
        width = firstLine.count
        height = lines.count
    }

    public func solvePart1() -> Int {
        grid.count {
            canBeRemoved(position: $0, from: grid)
        }
    }

    public func solvePart2() -> Int {
        var reducedGrid = grid
        while true {
            let positions = reducedGrid.filter {
                canBeRemoved(position: $0, from: reducedGrid)
            }
            if positions.isEmpty { break }
            reducedGrid.subtract(positions)
        }
        return grid.subtracting(reducedGrid).count
    }
    
    private func canBeRemoved(position: Position, from grid: Set<Position>) -> Bool {
        neighborPositions(of: position).intersection(grid).count < 4
    }
    
    private func neighborPositions(of position: Position) -> Set<Position> {
        Set(
            (-1 ... 1).flatMap { dy in
                (-1 ... 1).map { dx in
                    Position(x: position.x + dx, y: position.y + dy)
                }
            }
            .filter {
                $0 != position && isValid(position: $0)
            }
        )
    }
    
    private func isValid(position: Position) -> Bool {
        (0 ..< width).contains(position.x) && (0 ..< height).contains(position.y)
    }
}

private struct Position: Hashable {
    let x: Int
    let y: Int
}
