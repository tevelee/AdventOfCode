import Algorithms

@inlinable public func area(of polygon: [(x: Int, y: Int)]) -> Int {
    // https://en.wikipedia.org/wiki/Polygon#Simple_polygons
    var points = polygon
    if let first = points.first, let last = points.last, first != last {
        points.append(first)
    }
    return points.reversed().adjacentPairs().sum {
        ($0.x * $1.y) - ($0.y * $1.x)
    } / 2
}
