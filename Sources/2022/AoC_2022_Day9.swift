import RegexBuilder
import Utils

public final class AoC_2022_Day9 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await numberOfTailPositionsOfRope(size: 1)
    }

    public func solvePart2() async throws -> Int {
        try await numberOfTailPositionsOfRope(size: 9)
    }

    private func numberOfTailPositionsOfRope(size: Int) async throws -> Int {
        var rope = try Rope(size: size)
        var positions: Set<Position> = []
        for try await line in input.lines {
            let (direction, steps) = try parse(line: line)
            for _ in 1...steps {
                rope.drag(in: direction)
                positions.insert(rope.tail)
            }
        }
        return positions.count
    }
}

private struct Rope {
    var positions: [Position]
    var tail: Position {
        positions[positions.endIndex - 1]
    }
    private(set) var head: Position {
        get { positions[0] }
        set { positions[0] = newValue }
    }

    init(size: Int, at position: Position = Position(x: 0, y: 0)) throws {
        guard size >= 1 else {
            throw ParseError()
        }
        positions = Array(repeating: position, count: size + 1)
    }

    mutating func drag(in direction: Direction) {
        head.move(in: direction)
        for index in positions.indices.dropFirst() {
            positions[index].follow(positions[index - 1])
        }
    }
}

private enum Direction: Character {
    case up = "U"
    case down = "D"
    case `left` = "L"
    case `right` = "R"
}

private struct Position: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    var description: String { "(x: \(x), y: \(y))" }

    mutating func move(in direction: Direction) {
        switch direction {
        case .up:
            y += 1
        case .down:
            y -= 1
        case .left:
            x -= 1
        case .right:
            x += 1
        }
    }

    mutating func follow(_ other: Position) {
        let xDiff = other.x - x
        let yDiff = other.y - y
        if abs(xDiff) > 1 || abs(yDiff) > 1 {
            x += xDiff.clamped(to: -1...1)
            y += yDiff.clamped(to: -1...1)
        }
    }
}

private struct ParseError: Error {}

private func parse(line: String) throws -> (direction: Direction, steps: Int) {
    let regex = Regex {
        TryCapture {
            ChoiceOf {
                "U"
                "D"
                "L"
                "R"
            }
        } transform: {
            $0.first.flatMap(Direction.init)
        }
        " "
        Capture(.integer)
    }
    guard let output = line.wholeMatch(of: regex)?.output else {
        throw ParseError()
    }
    return (direction: output.1, steps: output.2)
}

private extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
