import AsyncAlgorithms
import Utils
import Accelerate

final class AoC_2023_Day24 {
    private let entries: [Entry]

    init(_ input: Input) throws {
        entries = try input.wholeInput.lines.map(Entry.init)
    }

    func solvePart1(_ range: ClosedRange<Double>) -> Int {
        entries.combinations(ofCount: 2)
            .map { ($0[0].line2D, $0[1].line2D) }
            .compactMap { $0.intersectionInFuture(with: $1) }
            .count { range.contains($0.x) && range.contains($0.y) }
    }

    func solvePart2() -> Int {
        let p1 = entries[0].point
        let v1 = entries[0].velocity
        let p2 = entries[1].point
        let v2 = entries[1].velocity
        let p3 = entries[2].point
        let v3 = entries[2].velocity

        let A: [[Double]] = [
            [-(v1.y - v2.y), v1.x - v2.x, 0, p1.y - p2.y, -(p1.x - p2.x), 0],
            [-(v1.y - v3.y), v1.x - v3.x, 0, p1.y - p3.y, -(p1.x - p3.x), 0],
            [0, -(v1.z - v2.z), v1.y - v2.y, 0, p1.z - p2.z, -(p1.y - p2.y)],
            [0, -(v1.z - v3.z), v1.y - v3.y, 0, p1.z - p3.z, -(p1.y - p3.y)],
            [-(v1.z - v2.z), 0, v1.x - v2.x, p1.z - p2.z, 0, -(p1.x - p2.x)],
            [-(v1.z - v3.z), 0, v1.x - v3.x, p1.z - p3.z, 0, -(p1.x - p3.x)]
        ]

        let b: [Double] = [
            (p1.y * v1.x - p2.y * v2.x) - (p1.x * v1.y - p2.x * v2.y),
            (p1.y * v1.x - p3.y * v3.x) - (p1.x * v1.y - p3.x * v3.y),
            (p1.z * v1.y - p2.z * v2.y) - (p1.y * v1.z - p2.y * v2.z),
            (p1.z * v1.y - p3.z * v3.y) - (p1.y * v1.z - p3.y * v3.z),
            (p1.z * v1.x - p2.z * v2.x) - (p1.x * v1.z - p2.x * v2.z),
            (p1.z * v1.x - p3.z * v3.x) - (p1.x * v1.z - p3.x * v3.z)
        ]

        let result = solveSystemOfEquations(matrix: A.flatMap { $0 }, vector: b)!.map { Int(round($0)) }
        print(result)
        return result.prefix(3).sum()
    }

    private func solveSystemOfEquations(matrix: [Double], vector: [Double]) -> [Double]? {
        let numRowsInt = vector.count // Number of equations
        let numRows = __CLPK_integer(numRowsInt)
        var numCols = __CLPK_integer(matrix.count / numRowsInt) // Number of unknowns

        var ata = Array(repeating: 0.0, count: Int(numCols * numCols))
        var atb = Array(repeating: 0.0, count: Int(numCols))
        for i in 0..<Int(numCols) {
            for j in 0..<Int(numCols) {
                for k in 0..<Int(numRows) {
                    ata[i * Int(numCols) + j] += matrix[k * Int(numCols) + i] * matrix[k * Int(numCols) + j]
                }
            }
            for k in 0..<Int(numRows) {
                atb[i] += matrix[k * Int(numCols) + i] * vector[k]
            }
        }

        var solutions = Array(repeating: 0.0, count: Int(numCols))
        var nrhs = __CLPK_integer(1)
        var lda = numCols
        var ldb = numCols
        var ipiv: [__CLPK_integer] = Array(repeating: 0, count: Int(numCols))
        var info: __CLPK_integer = 0

        ata.withUnsafeMutableBufferPointer { ataPtr in
            atb.withUnsafeMutableBufferPointer { atbPtr in
                ipiv.withUnsafeMutableBufferPointer { ipivPtr in
                    dgesv_(&numCols, &nrhs, ataPtr.baseAddress!, &lda, ipivPtr.baseAddress!, atbPtr.baseAddress!, &ldb, &info)
                    if info == 0 {
                        solutions = Array(atbPtr)
                    }
                }
            }
        }

        return info == 0 ? solutions : nil
    }
}

private struct Entry {
    let point: Coordinates3D
    let velocity: Coordinates3D

    var line2D: Line2D {
        Line2D(
            point: Coordinates2D(x: point.x, y: point.y),
            direction: Coordinates2D(x: velocity.x, y: velocity.y)
        )
    }

    var line3D: Line3D {
        Line3D(
            point: point,
            direction: velocity
        )
    }
}

extension Entry {
    init(rawString: String) throws {
        let parts = rawString.components(separatedBy: " @ ")
        guard parts.count == 2 else { throw ParseError() }
        point = try Coordinates3D(rawString: parts[0])
        velocity = try Coordinates3D(rawString: parts[1])
    }
}

private struct Coordinates3D {
    let x, y, z: Double

    static var zero: Coordinates3D { .init(x: 0, y: 0, z: 0) }

    func isEqual(_ other: Coordinates3D, tolerance: Double = 1e-10) -> Bool {
        x.isEqual(other.x, tolerance: tolerance) &&
        y.isEqual(other.y, tolerance: tolerance) &&
        z.isEqual(other.z, tolerance: tolerance)
    }
}

private extension Double {
    func isEqual(_ other: Double, tolerance: Double = 1e-10) -> Bool {
        abs(self - other) < tolerance
    }
}

extension Coordinates3D {
    init(rawString: String) throws {
        let coordinates = rawString.integers.map(Double.init)
        guard coordinates.count == 3 else { throw ParseError() }
        (x, y, z) = (coordinates[0], coordinates[1], coordinates[2])
    }
}

private struct Coordinates2D {
    let x, y: Double

    func isEqual(_ other: Coordinates2D, tolerance: Double = 1e-10) -> Bool {
        x.isEqual(other.x, tolerance: tolerance) &&
        y.isEqual(other.y, tolerance: tolerance)
    }
}

private struct Line2D {
    var point: Coordinates2D
    var direction: Coordinates2D

    func intersectionInFuture(with other: Line2D) -> Coordinates2D? {
        guard let point = intersection(with: other),
              isInDirection(point),
              other.isInDirection(point) else {
            return nil
        }
        return point
    }

    private func isInDirection(_ p: Coordinates2D) -> Bool {
        (p.x - point.x) / direction.x >= 0 && (p.y - point.y) / direction.y >= 0
    }

    func intersection(with other: Line2D) -> Coordinates2D? {
        guard !isParallel(with: other),
              let slope1 = self.slope, let yIntercept1 = self.yIntercept,
              let slope2 = other.slope, let yIntercept2 = other.yIntercept else {
            return nil
        }
        let x = (yIntercept2 - yIntercept1) / (slope1 - slope2)
        let y = slope1 * x + yIntercept1
        return Coordinates2D(x: x, y: y)
    }

    func isParallel(with other: Line2D) -> Bool {
        guard let slope1 = self.slope, let slope2 = other.slope else {
            return false
        }
        return slope1.isEqual(slope2)
    }

    private var slope: Double? {
        if direction.x == 0 {
            return nil
        }
        return direction.y / direction.x
    }

    private var yIntercept: Double? {
        guard let slope = slope else {
            return nil
        }
        return point.y - slope * point.x
    }
}

private struct Line3D {
    var point: Coordinates3D
    var direction: Coordinates3D

    func intersection(with other: Line3D) -> Coordinates3D? {
        let (line1, line2) = (self, other)
        let p1 = line1.point
        let d1 = line1.direction
        let p2 = line2.point
        let d2 = line2.direction

        let crossD = crossProduct(d1, d2)

        if crossD.isEqual(.zero) {
            return nil
        }

        let det = determinant(
            p2.x - p1.x, d2.x, d1.x,
            p2.y - p1.y, d2.y, d1.y,
            p2.z - p1.z, d2.z, d1.z
        )

        if det == 0 {
            return nil
        }

        let t = determinant(p2.x - p1.x, p2.y - p1.y, p2.z - p1.z,
                            d2.x, d2.y, d2.z,
                            crossD.x, crossD.y, crossD.z) / det

        return Coordinates3D(x: p1.x + t * d1.x, y: p1.y + t * d1.y, z: p1.z + t * d1.z)
    }

    private func crossProduct(_ a: Coordinates3D, _ b: Coordinates3D) -> Coordinates3D {
        Coordinates3D(
            x: a.y * b.z - a.z * b.y,
            y: a.z * b.x - a.x * b.z,
            z: a.x * b.y - a.y * b.x
        )
    }

    private func determinant(
        _ a1: Double, _ a2: Double, _ a3: Double,
        _ b1: Double, _ b2: Double, _ b3: Double,
        _ c1: Double, _ c2: Double, _ c3: Double
    ) -> Double {
        a1 * (b2 * c3 - b3 * c2) -
        a2 * (b1 * c3 - b3 * c1) +
        a3 * (b1 * c2 - b2 * c1)
    }
}
