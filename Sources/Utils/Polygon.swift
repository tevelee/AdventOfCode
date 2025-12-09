import Algorithms
import Foundation

@inlinable public func area(of polygon: [(x: Int, y: Int)]) -> Int {
    // https://en.wikipedia.org/wiki/Polygon#Simple_polygons
    abs(closed(polygon).adjacentPairs().sum {
        ($0.x * $1.y) - ($0.y * $1.x)
    }) / 2
}

@inlinable public func isPointInside(_ point: (Int, Int), polygon: [(x: Int, y: Int)]) -> Bool {
    isPointOnBoundary(point, polygon: polygon) || isPointInsideByRayCasting(point, polygon: polygon)
}

@inlinable public func isPointOnBoundary(_ point: (Int, Int), polygon: [(x: Int, y: Int)]) -> Bool {
    let x = point.0
    let y = point.1

    for (a, b) in closed(polygon).adjacentPairs() {
        let cross = (b.x - a.x) * (y - a.y) - (b.y - a.y) * (x - a.x)
        if cross == 0 {
            if min(a.x, b.x) <= x, x <= max(a.x, b.x),
               min(a.y, b.y) <= y, y <= max(a.y, b.y) {
                return true
            }
        }
    }

    return false
}

@usableFromInline func isPointInsideByRayCasting(_ point: (Int, Int), polygon: [(x: Int, y: Int)]) -> Bool {
    let x = point.0
    let y = point.1
    var inside = false

    for (a, b) in closed(polygon).adjacentPairs() {
        let yi = a.y, yj = b.y
        let xi = a.x, xj = b.x

        let intersects = ((yi > y) != (yj > y)) &&
            (Double(x) < (Double(xj - xi) * Double(y - yi)) / Double(yj - yi) + Double(xi))

        if intersects {
            inside.toggle()
        }
    }

    return inside
}

@inlinable public func circumference(
    of polygon: [(x: Int, y: Int)],
    using distance: ((Int, Int), (Int, Int)) -> Int = manhattanDistance
) -> Int {
    closed(polygon).adjacentPairs().sum(of: distance)
}

@usableFromInline func closed(_ points: [(x: Int, y: Int)]) -> [(x: Int, y: Int)] {
    if let first = points.first, let last = points.last, first != last {
        points + [first]
    } else {
        points
    }
}

@inlinable public func numberOfPoints(
    inside polygon: [(x: Int, y: Int)],
    using distance: ((Int, Int), (Int, Int)) -> Int = manhattanDistance
) -> Int {
    area(of: polygon) - circumference(of: polygon, using: distance) / 2 + 1
}

@inlinable public func manhattanDistance(_ one: (x: Int, y: Int), _ two: (x: Int, y: Int)) -> Int {
    abs(one.x - two.x) + abs(one.y - two.y)
}

@inlinable public func euclideanDistance(_ one: (x: Int, y: Int), _ two: (x: Int, y: Int)) -> Int {
    Int(euclideanDistance(one, two))
}

@inlinable public func euclideanDistance(_ one: (x: Double, y: Double), _ two: (x: Double, y: Double)) -> Double {
    sqrt(pow(one.x - two.x, 2) + pow(one.y - two.y, 2))
}

@inlinable public func euclideanDistance(_ one: (x: Int, y: Int), _ two: (x: Int, y: Int)) -> Double {
    euclideanDistance((x: Double(one.x), y: Double(one.y)), (x: Double(two.x), y: Double(two.y)))
}
