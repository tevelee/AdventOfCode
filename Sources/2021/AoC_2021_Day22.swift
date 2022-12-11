import Algorithms
import Utils
import RegexBuilder

public final class AoC_2021_Day22 {
    private let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ input: String) {
        lines = input.lines.async.eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await solve(bounds: Cuboid(all: -50 ... 50))
    }

    public func solvePart2() async throws -> Int {
        try await solve(bounds: nil)
    }

    private func solve(bounds: Cuboid?) async throws -> Int {
        var on: [Cuboid] = []
        var off: [Cuboid] = []

        for try await line in lines.compactMap({ try self.parse(line: $0) }) where line.ranges.overlaps(bounds) {
            let cuboid = line.ranges.clamped(to: bounds)
            let originalOff = off
            if line.isOn {
                for other in on where other.overlaps(cuboid) {
                    off.append(cuboid.clamped(to: other))
                }
                for other in originalOff where other.overlaps(cuboid) {
                    on.append(cuboid.clamped(to: other))
                }
                on.append(cuboid)
            } else {
                for other in on where other.overlaps(cuboid) {
                    off.append(cuboid.clamped(to: other))
                }
                for other in originalOff where other.overlaps(cuboid) {
                    on.append(cuboid.clamped(to: other))
                }
            }
        }

        return on.sum(of: \.numberOfPoints) - off.sum(of: \.numberOfPoints)
    }

    private struct ParsingError: Error {}

    private func parse(line: String) throws -> (isOn: Bool, ranges: Cuboid) {
        let number = TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
        let regex = Regex {
            Capture {
                ChoiceOf {
                    "on"
                    "off"
                }
            } transform: {
                $0 == "on"
            }
            " x="
            number
            ".."
            number
            ",y="
            number
            ".."
            number
            ",z="
            number
            ".."
            number
        }
        guard let output = line.wholeMatch(of: regex)?.output else {
            throw ParsingError()
        }
        return (output.1, Cuboid(x: output.2...output.3,
                                 y: output.4...output.5,
                                 z: output.6...output.7))
    }
}

private struct ThreeDimensional<T> {
    let x, y, z: T

    init(all value: T) {
        x = value
        y = value
        z = value
    }

    init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }

    func map<K>(transform: @escaping (T) -> K) -> ThreeDimensional<K> {
        .init(x: transform(x),
              y: transform(y),
              z: transform(z))
    }
}

extension ThreeDimensional: Equatable where T: Equatable {}
extension ThreeDimensional: Hashable where T: Hashable {}

private typealias Cuboid = ThreeDimensional<ClosedRange<Int>>

extension Cuboid {
    func clamped(to other: Cuboid) -> Cuboid {
        Cuboid(x: x.clamped(to: other.x),
               y: y.clamped(to: other.y),
               z: z.clamped(to: other.z))
    }

    func overlaps(_ other: Cuboid) -> Bool {
        x.overlaps(other.x) &&
        y.overlaps(other.y) &&
        z.overlaps(other.z)
    }

    func clamped(to other: Cuboid?) -> Cuboid {
        guard let other = other else {
            return self
        }
        return clamped(to: other)
    }

    func overlaps(_ other: Cuboid?) -> Bool {
        guard let other = other else {
            return true
        }
        return overlaps(other)
    }

    var numberOfPoints: Int {
        x.count * y.count * z.count
    }
}
