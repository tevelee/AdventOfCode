import Algorithms
import RegexBuilder
import Utils

public final class AoC_2022_Day15 {
    private let sensorsAndBeacons: [(Position, closestBeacon: Position)]

    public init(_ input: Input) throws {
        let positionRegex = Regex {
            "x="
            Capture {
                Integer()
            }
            ", y="
            Capture {
                Integer()
            }
        }
        let regex = Regex {
            "Sensor at "
            positionRegex
            ": closest beacon is at "
            positionRegex
        }
        sensorsAndBeacons = try input.wholeInput.lines.map { line in
            guard let output = line.wholeMatch(of: regex)?.output else {
                throw ParseError()
            }
            return (Position(x: output.1, y: output.2), Position(x: output.3, y: output.4))
        }
    }

    public func solvePart1(y: Int) throws -> Int {
        let rangesOnY = sensorsAndBeacons
            .map(Coverage.init)
            .map { $0.xCoordinates(onY: y) }
            .filter(!\.isEmpty)
            .sorted(by: \.lowerBound)
        let sumOfLengths = combineOverlappingRanges(in: rangesOnY)
            .sum(of: \.length)

        let numberOfBeaconsOnY = sensorsAndBeacons
            .map(\.closestBeacon)
            .uniqued()
            .count { $0.y == y }

        return sumOfLengths - numberOfBeaconsOnY
    }

    public func solvePart2(range: ClosedRange<Int>) throws -> Int {
        let areas = sensorsAndBeacons.map(Coverage.init).sorted(by: \.radius)
        for area in areas {
            for position in area.increasingRadius(by: 1).border() {
                if range.contains(position.x),
                   range.contains(position.y),
                   areas.allSatisfy({ !$0.contains(position) }) {
                    return position.tuningFrequency
                }
            }
        }
        return 0
    }

    private func combineOverlappingRanges(in ranges: [Range<Int>]) -> [Range<Int>] {
        let pairs = ranges.enumerated().adjacentPairs()
        let overlapping = pairs.first { $0.element.overlaps($1.element) }
        if let (first, second) = overlapping {
            let index1 = first.offset
            let index2 = second.offset
            let lower = Swift.min(first.element.lowerBound, second.element.lowerBound)
            let upper = Swift.max(first.element.upperBound, second.element.upperBound)
            let combined = lower..<upper

            var ranges = ranges
            ranges.remove(at: index2)
            ranges.remove(at: index1)
            ranges.insert(combined, at: index1)
            return combineOverlappingRanges(in: ranges)
        }
        return ranges
    }
}

private struct Coverage {
    let center: Position
    var radius: Int

    init(center: Position, onePointOnTheBorder borderPoint: Position) {
        self.center = center
        self.radius = center.distance(to: borderPoint)
    }

    func increasingRadius(by value: Int) -> Coverage {
        var copy = self
        copy.radius += value
        return copy
    }

    func contains(_ position: Position) -> Bool {
        center.distance(to: position) <= radius
    }

    func border() -> some Sequence<Position> {
        (-radius...radius).lazy.flatMap { r in
            [
                Position(x: center.x + r, y: center.y + radius - abs(r)),
                Position(x: center.x + r, y: center.y - radius + abs(r))
            ]
        }
    }

    func xCoordinates(onY y: Int) -> Range<Int> {
        let distance = abs(center.y - y)
        guard radius > distance else {
            return 0 ..< 0
        }
        let remainder = radius - distance
        return (center.x - remainder) ..< (center.x + remainder + 1)
    }
}

private struct Position: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String { "(\(x),\(y))" }

    func distance(to other: Position) -> Int {
        abs(other.x - self.x) + abs(other.y - self.y)
    }

    var tuningFrequency: Int { x * 4_000_000 + y }
}

private struct ParseError: Error {}

extension Range<Int> {
    var length: Int {
        upperBound - lowerBound
    }
}
