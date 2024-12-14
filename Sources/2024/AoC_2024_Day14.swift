import Utils

public final class AoC_2024_Day14 {
    private let robots: [Robot]

    public init(_ input: Input) throws {
        robots = try input.wholeInput.lines.compactMap { line in
            guard let match = line.wholeMatch(of: /p=(?<px>\d+),(?<py>\d+) v=(?<vx>\-?\d+),(?<vy>\-?\d+)/),
                let px = Int(match.px), let py = Int(match.py), let vx = Int(match.vx), let vy = Int(match.vy) else { return nil }
            return Robot(position: SIMD2(px, py), velocity: SIMD2(vx, vy))
        }
    }

    public func solvePart1(width: Int = 101, height: Int = 103) -> Int {
        let halfWidth = (width - 1) / 2
        let halfHeight = (height - 1) / 2
        return robots
            .map { robot in
                robot.advanced(times: 100, width: width, height: height)
            }
            .grouped { robot in
                switch (robot.position.x, robot.position.y) {
                case (0 ..< halfWidth, 0 ..< halfHeight): "top left"
                case (0 ..< halfWidth, halfHeight + 1 ... height): "bottom left"
                case (halfWidth + 1 ... width, 0 ..< halfHeight): "top right"
                case (halfWidth + 1 ... width, halfHeight + 1 ... height): "bottom right"
                default: "divider"
                }
            }
            .filter { $0.key != "divider" }
            .product(of: \.value.count)
    }

    public func solvePart2(width: Int = 101, height: Int = 103) -> Int {
        var robots = robots
        var i = 0
        while true {
            i += 1
            robots = robots.map { $0.advanced(width: width, height: height) }
            let positions = Set(robots.map(\.position))
            if (37...66).allSatisfy({ positions.contains(SIMD2($0, 23)) }) {
                return i
            }
//            let hasLargeRow = (0 ..< height / 3).contains { y in
//                (0 ..< width).windows(ofCount: 25).contains {
//                    $0.allSatisfy { x in
//                        positions.contains(SIMD2(x, y))
//                    }
//                }
//            }
//            if hasLargeRow {
//                return i
//            }
        }
        return 0
    }
}

private struct Robot {
    let position: SIMD2<Int>
    let velocity: SIMD2<Int>

    func advancedPosition(times: Int = 1) -> SIMD2<Int> {
        position &+ times &* velocity
    }

    func advanced(times: Int = 1, width: Int, height: Int) -> Robot {
        let nextPosition = advancedPosition(times: times)
        return Robot(position: SIMD2(
            nonNegativeModulo(of: nextPosition.x, by: width),
            nonNegativeModulo(of: nextPosition.y, by: height)
        ), velocity: velocity)
    }
}
