import Utils

public final class AoC_2025_Day4 {
    private let grid: [[Bool]]
    private let width: Int
    private let height: Int
    
    public init(_ input: Input) throws {
        grid = try input.wholeInput.lines.map { $0.map { $0 == "@" } }
        guard let firstLine = grid.first else { throw ParseError("empty row") }
        width = firstLine.count
        height = grid.count
    }
    
    public func solvePart1() -> Int {
        grid.indices.sum { y in
            grid[y].indices.count { x in
                shouldRemove(x: x, y: y, in: grid)
            }
        }
    }

    public func solvePart2() -> Int {
        var result = 0
        var grid = grid
        while true {
            var count = 0
            for y in grid.indices {
                for x in grid[y].indices where shouldRemove(x: x, y: y, in: grid) {
                    grid[y][x] = false
                    count += 1
                }
            }
            if count == 0 { break }
            result += count
        }
        return result
    }
    
    private func shouldRemove(x: Int, y: Int, in grid: [[Bool]]) -> Bool {
        if grid[y][x] {
            neighbors(x: x, y: y, in: grid).count { grid[$0.y][$0.x] } <= 4
        } else {
            false
        }
    }

    private func neighbors(x: Int, y: Int, in grid: [[Bool]]) -> [(x: Int, y: Int)] {
        (max(0, y - 1) ... min(height - 1, y + 1)).flatMap { py in
            (max(0, x - 1) ... min(width - 1, x + 1)).map { px in
                (x: px, y: py)
            }
        }
    }
}
