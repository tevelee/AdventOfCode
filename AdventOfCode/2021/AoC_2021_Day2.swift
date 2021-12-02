import Foundation
import Parsing

public final class AoC_2021_Day2 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        var location = Point()
        for try await line in inputFileURL.lines {
            let (command, length) = parse(line: line)

            switch command {
                case .up:
                    location.depth -= length
                case .down:
                    location.depth += length
                case .forward:
                    location.horizontal += length
            }
        }
        return location.horizontal * location.depth
    }

    public func solvePart2() async throws -> Int {
        var location = Point()
        var aim = 0
        for try await line in inputFileURL.lines {
            let (command, length) = parse(line: line)

            switch command {
                case .up:
                    aim -= length
                case .down:
                    aim += length
                case .forward:
                    location.horizontal += length
                    location.depth += aim * length
            }
        }
        return location.horizontal * location.depth
    }

    private func parse(line: String) -> (Command, Int) {
        let values = line.split(separator: " ")
        let command = Command(rawValue: String(values[0]))!
        let length = Int(values[1])!
        return (command, length)
    }

    struct Point {
        var horizontal: Int = 0
        var depth: Int = 0
    }

    enum Command: String, RawRepresentable {
        case up, down, forward
    }
}

private extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

private extension Substring {
    subscript(index i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}
