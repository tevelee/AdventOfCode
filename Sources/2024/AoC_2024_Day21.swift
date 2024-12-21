import Utils

public final class AoC_2024_Day21 {
    private let codes: [String]

    public init(_ input: Input) throws {
        codes = try Array(input.wholeInput.lines)
    }

    private typealias Pad = [Character: Position]
    private typealias Segment = [Character]

    private lazy var numPad = positions(of: """
    789
    456
    123
     0A
    """)

    private lazy var arrowPad = positions(of: """
     ^A
    <v>
    """)

    public func solvePart1() -> Int {
        solve(robots: 2)
    }

    public func solvePart2() -> Int {
        solve(robots: 25)
    }

    public func solve(robots: Int) -> Int {
        codes.sum {
            lengthOfShortestSequence(of: Array($0), on: numPad, depth: robots) * numberValue(of: $0)
        }
    }

    private func lengthOfShortestSequence(of segment: Segment, on pad: Pad, depth: Int) -> Int {
        shortestSequence(of: segment, on: pad).sum {
            lengthOfShortestSequence($0, depth)
        }
    }

    private lazy var lengthOfShortestSequence = memoize(_lengthOfShortestSequence)
    private func _lengthOfShortestSequence(of segment: Segment, depth: Int) -> Int {
        if depth == 0 {
            segment.count
        } else {
            lengthOfShortestSequence(of: segment, on: arrowPad, depth: depth - 1)
        }
    }

    private func shortestSequence(of code: Segment, on pad: Pad) -> [Segment] {
        var result: [Segment] = []
        var currentPosition = pad["A"]!
        for character in code {
            let targetPosition = pad[character]!
            let path = optimalPath(from: currentPosition, to: targetPosition, avoiding: pad[" "]!) + ["A"]
            result.append(path)
            currentPosition = targetPosition
        }
        return result
    }

    private func numberValue(of code: String) -> Int {
        Int(code.dropLast()) ?? 0
    }

    private func positions(of pad: String) -> Pad {
        Dictionary(uniqueKeysWithValues: pad.lines.enumerated().flatMap { row, line in
            line.enumerated().map { column, character in
                (key: character, value: Position(x: column, y: row))
            }
        })
    }
}

private typealias Position = SIMD2<Int>

private func optimalPath(from start: Position, to end: Position, avoiding obstacle: Position) -> [Character] {
    var path: [Character] = []
    let hitsObstacleHorizontally = obstacle.y == start.y && ClosedRange(unorderedBounds: (start.x, end.x)).contains(obstacle.x)
    let hitsObstacleVertically = obstacle.x == start.x && ClosedRange(unorderedBounds: (start.y, end.y)).contains(obstacle.y)
    let moveRight = start.x > end.x
    var current = start
    if hitsObstacleHorizontally || !(hitsObstacleVertically || moveRight) {
        moveVertical(of: &current, to: end, path: &path)
        moveHorizontal(of: &current, to: end, path: &path)
    } else {
        moveHorizontal(of: &current, to: end, path: &path)
        moveVertical(of: &current, to: end, path: &path)
    }
    return path
}

private func moveVertical(of current: inout Position, to end: Position, path: inout [Character]) {
    while current.y != end.y {
        path.append(current.y < end.y ? "v" : "^")
        current.y += current.y < end.y ? 1 : -1
    }
}

private func moveHorizontal(of current: inout Position, to end: Position, path: inout [Character]) {
    while current.x != end.x {
        path.append(current.x < end.x ? ">" : "<")
        current.x += current.x < end.x ? 1 : -1
    }
}

private extension ClosedRange where Bound: Comparable {
    init(unorderedBounds: (Bound, Bound)) {
        self.init(uncheckedBounds: (
            Swift.min(unorderedBounds.0, unorderedBounds.1),
            Swift.max(unorderedBounds.0, unorderedBounds.1)
        ))
    }
}
