import Foundation
import Parsing

public final class AoC_2021_Day5 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    struct Line: Hashable {
        let p1: Point
        let p2: Point

        var isHorizontal: Bool { p1.y == p2.y }
        var isVertical: Bool { p1.x == p2.x }
        var isDiagonal: Bool { abs(p1.x - p2.x) == abs(p1.y - p2.y) }

        func points(shouldConsiderDiagonal: Bool) -> [Point] {
            var points: [Point] = []
            if isHorizontal {
                for x in min(p1.x, p2.x) ... max(p1.x, p2.x) {
                    points.append(Point(x: x, y: p1.y))
                }
            } else if isVertical {
                for y in min(p1.y, p2.y) ... max(p1.y, p2.y) {
                    points.append(Point(x: p1.x, y: y))
                }
            } else if shouldConsiderDiagonal, isDiagonal {
                let x = p2.x > p1.x ? 1 : -1
                let y = p2.y > p1.y ? 1 : -1
                for i in 0 ... abs(p1.x - p2.x) {
                    points.append(Point(x: p1.x + i * x, y: p1.y + i * y))
                }
            }
            return points
        }
    }

    public func solvePart1() async throws -> Int {
        try await solve(shouldConsiderDiagonal: false)
    }

    public func solvePart2() async throws -> Int {
        try await solve(shouldConsiderDiagonal: true)
    }

    private func solve(shouldConsiderDiagonal: Bool) async throws -> Int {
        var touchPoints: [Point: Int] = [:]
        for try await inputLine in inputFileURL.lines {
            let segments = inputLine.split(separator: " ").map { $0.split(separator: ",").map(String.init).compactMap(Int.init) }
            let line = Line(p1: .init(x: segments[0][0], y: segments[0][1]),
                            p2: .init(x: segments[2][0], y: segments[2][1]))
            for point in line.points(shouldConsiderDiagonal: shouldConsiderDiagonal) {
                touchPoints[point, default: 0] += 1
            }
        }
        return touchPoints.filter { $0.value > 1 }.count
    }
}
