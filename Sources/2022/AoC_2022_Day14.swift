import Algorithms

public final class AoC_2022_Day14 {
    private let paths: [[Point]]
    private let spawnPosition = Point(x: 500, y: 0)

    public init(_ input: Input) throws {
        paths = try input.wholeInput.lines.map(parsePath)
    }

    public func solvePart1() throws -> Int {
        var sandPoints: Set<Point> = []
        while let point = simulateFallOfNewPoint(sandPoints, shouldDiscard: { $0.y >= self.lowestPosition }) {
            sandPoints.insert(point)
        }
        //visualize(sandPoints)
        return sandPoints.count
    }

    public func solvePart2() throws -> Int {
        var sandPoints: Set<Point> = []
        while let point = simulateFallOfNewPoint(sandPoints, shouldStop: { $0.y == self.lowestPosition + 1 }) {
            sandPoints.insert(point)
            if point == spawnPosition {
                //visualize(sandPoints)
                return sandPoints.count
            }
        }
        fatalError()
    }

    private lazy var lowestPosition: Int = paths.flatMap { $0 }.map(\.y).max()!
    private lazy var wallPoints: Set<Point> = paths.map { $0.adjacentPairs().map(pointsBetween).union() }.union()

    private func simulateFallOfNewPoint(_ sandPoints: Set<Point>,
                                        shouldStop: (Point) -> Bool = { _ in false },
                                        shouldDiscard: (Point) -> Bool = { _ in false }) -> Point? {
        var sand = spawnPosition
        while !shouldDiscard(sand) {
            let nextPoint = sand.apply { $0.y += 1 }
            let nextPointToTheLeft = nextPoint.apply { $0.x -= 1 }
            let nextPointToTheRight = nextPoint.apply { $0.x += 1 }
            let points = [nextPoint, nextPointToTheLeft, nextPointToTheRight]
            if !shouldStop(sand), let point = points.first(where: { !sandPoints.contains($0) && !wallPoints.contains($0) }) {
                sand = point
            } else {
                return sand
            }
        }
        return nil
    }

    private func pointsBetween(a: Point, b: Point) -> Set<Point> {
        if a.x == b.x {
            return Set(range(from: a.y, to: b.y).map { Point(x: a.x, y: $0) })
        } else if a.y == b.y {
            return Set(range(from: a.x, to: b.x).map { Point(x: $0, y: a.y) })
        } else {
            fatalError()
        }
    }

    private func visualize(_ points: Set<Point>) {
        let width = points.union(wallPoints).map(\.x).minAndMax()!
        for y in spawnPosition.y...lowestPosition {
            for x in width.min...width.max {
                let point = Point(x: x, y: y)
                if wallPoints.contains(point) {
                    print("#", terminator: "")
                } else if points.contains(point) {
                    print("o", terminator: "")
                } else if point == spawnPosition {
                    print("+", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
    }
}

private struct Point: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String { "(\(x),\(y))" }

    func apply(block: (inout Point) -> Void) -> Point {
        var copy = self
        block(&copy)
        return copy
    }
}

private func parsePath(from string: String) throws -> [Point] {
    try Array(string.split(separator: " -> ").compactMap(parsePoint))
}

private func parsePoint(from string: Substring) throws -> Point? {
    try string.wholeMatch(of: /(\d+),(\d+)/).map { match -> Point in
        guard let x = Int(match.output.1), let y = Int(match.output.2) else {
            throw ParseError()
        }
        return Point(x: x, y: y)
    }
}

private func range(from: Int, to: Int) -> ClosedRange<Int> {
    min(from, to) ... max(from, to)
}

private struct ParseError: Error {}

private extension Collection where Element == Set<Point> {
    func union() -> Set<Point> {
        reduce(into: []) { $0.formUnion($1) }
    }
}
