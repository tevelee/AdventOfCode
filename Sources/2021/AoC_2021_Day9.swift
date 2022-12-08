import Algorithms

public final class AoC_2021_Day9 {
    let points: [[Int]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        points = input.lines.map { line in
            line.compactMap(\.wholeNumberValue)
        }
    }

    public func solvePart1() async throws -> Int {
        var heights: [Int] = []
        for (row, line) in points.enumerated() {
            for (column, height) in line.enumerated() {
                let adjacentPoints = [
                    points[safe: row-1]?[column],
                    points[safe: row+1]?[column],
                    points[row][safe: column-1],
                    points[row][safe: column+1]
                ].compactMap { $0 }
                if adjacentPoints.allSatisfy({ height < $0 }) {
                    heights.append(height)
                }
            }
        }
        return heights.map { $0 + 1 }.reduce(0, +)
    }

    public func solvePart2() async throws -> Int {
        var basins: [Basin] = []
        var pointsToSkip: Set<Point> = []
        for (row, line) in points.enumerated() {
            for (column, height) in line.enumerated() {
                if height == 9 || pointsToSkip.contains(where: { $0.row == row && $0.column == column }) {
                    continue
                }
                let basin = self.basin(row: row, column: column, in: points)
                basins.append(basin)
                //debugPrint(basin, points)
                pointsToSkip.formUnion(basin)
            }
        }
        return basins.map(\.count).max(count: 3).reduce(1, *)
    }

    struct Point: Hashable {
        let row: Int
        let column: Int
    }
    typealias Basin = Set<Point>

    private func basin(row: Int, column: Int, existingBasin: Basin = [], in points: [[Int]]) -> Basin {
        var adjacentPoints: [Point] = []
        if row > 0 { adjacentPoints.append(Point(row: row - 1, column: column)) }
        if column > 0 { adjacentPoints.append(Point(row: row, column: column - 1)) }
        if row < points.count - 1 { adjacentPoints.append(Point(row: row + 1, column: column)) }
        if column < points[0].count - 1 { adjacentPoints.append(Point(row: row, column: column + 1)) }

        let current = Point(row: row, column: column)

        var existingBasin = existingBasin.union([current])
        for point in adjacentPoints where points[point.row][point.column] != 9 && !existingBasin.contains(point) {
            let additional = basin(row: point.row, column: point.column, existingBasin: existingBasin, in: points)
            existingBasin.formUnion(additional)
        }
        return existingBasin
    }

    private func debugPrint(_ basin: Basin, _ points: [[Int]]) {
        //print("Original")
        //for line in points {
        //    for height in line {
        //        print(String(height), terminator: "")
        //    }
        //    print()
        //}
        print("Basin")
        for (row, line) in points.enumerated() {
            for (column, height) in line.enumerated() {
                let character = basin.contains(Point(row: row, column: column)) ? "*" : String(height)
                print(character, terminator: "")
            }
            print()
        }
    }
}
