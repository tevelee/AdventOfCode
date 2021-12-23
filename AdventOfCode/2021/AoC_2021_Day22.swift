import Algorithms
import Foundation
import Parsing

public final class AoC_2021_Day22 {
    private let lines: Lines
    private lazy var lineParser: AnyParser<Substring, (isOn: Bool, ranges: Cuboid)> = {
        let rangeParser = Int.parser().skip("..").take(Int.parser()).map(ClosedRange<Int>.init)
        let cuboidParser = "x="
            .take(rangeParser)
            .skip(",y=")
            .take(rangeParser)
            .skip(",z=")
            .take(rangeParser)
            .map(Cuboid.init)
        let onOrOff = Parsers.OneOf("on".eraseToAnyParser().map { _ in true },
                                    "off".map { _ in false })
        return onOrOff.skip(" ").take(cuboidParser).skip(End()).map { ($0, $1) }.eraseToAnyParser()
    }()

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

        for try await line in lines.compactMap(lineParser.parse) where line.ranges.overlaps(bounds) {
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

        return on.map(\.numberOfPoints).reduce(0, +) - off.map(\.numberOfPoints).reduce(0, +)
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
