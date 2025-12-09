import Utils

public final class AoC_2025_Day9 {
    private typealias Coordinate = (x: Int, y: Int)
    private let points: [Coordinate]

    public init(_ input: Input) throws {
        points = try input.wholeInput.lines.map { try $0.integers.elements() }
    }

    public func solvePart1() -> Int {
        points.allPairs().maxValue(of: areaOfRectangle) ?? 0
    }

    public func solvePart2() -> Int {
        points
            .allPairs()
            .filter(isRectangleValid)
            .map(areaOfRectangle)
            .max() ?? 0
    }

    private func areaOfRectangle(_ c1: Coordinate, _ c2: Coordinate) -> Int {
        (abs(c1.x - c2.x) + 1) * (abs(c1.y - c2.y) + 1)
    }

    private func isRectangleValid(_ c1: Coordinate, _ c2: Coordinate) -> Bool {
        guard c1.x != c2.x, c1.y != c2.y else { return false }

        let xMin = min(c1.x, c2.x)
        let xMax = max(c1.x, c2.x)
        let yMin = min(c1.y, c2.y)
        let yMax = max(c1.y, c2.y)

        let cx = (xMin + xMax) / 2
        let cy = (yMin + yMax) / 2

        return isPointInside((cx, cy), polygon: points)
            && !polygonInteriorCrossesRectangle(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
    }

    private func polygonInteriorCrossesRectangle(
        xMin: Int, xMax: Int,
        yMin: Int, yMax: Int
    ) -> Bool {
        points.adjacentPairs().contains { a, b in
            if a.x == b.x {
                let x = a.x
                guard xMin < x && x < xMax else { return false }
                let sy0 = min(a.y, b.y)
                let sy1 = max(a.y, b.y)
                return max(yMin, sy0) < min(yMax, sy1)
            } else if a.y == b.y {
                let y = a.y
                guard yMin < y && y < yMax else { return false }
                let sx0 = min(a.x, b.x)
                let sx1 = max(a.x, b.x)
                return max(xMin, sx0) < min(xMax, sx1)
            } else {
                return false
            }
        }
    }
}
