import Utils

public final class AoC_2025_Day8 {
    private let coordinates: [Coordinate]

    public init(_ input: Input) throws {
        coordinates = try input.wholeInput.lines
            .map { try $0.integers.elements() }
            .map(Coordinate.init)
    }
    
    private lazy var pairsSortedByDistances: [(Coordinate, Coordinate)] = coordinates.combinations(ofCount: 2)
        .compactMap { try? $0.elements() }
        .filter { $0 != $1 }
        .grouped { $0.distance(to: $1) }
        .sorted(by: \.key)
        .flatMap(\.value)

    public func solvePart1(until: Int) -> Int {
        var boxes: Set<Set<Coordinate>> = Set(coordinates.map { [$0] })
        for pair in pairsSortedByDistances.prefix(until) {
            let box1 = boxes.first { $0.contains(pair.0) } ?? []
            boxes.remove(box1)
            let box2 = boxes.first { $0.contains(pair.1) } ?? []
            boxes.remove(box2)
            boxes.insert(box1.union(box2))
        }
        return boxes.map(\.count).sorted(by: >).prefix(3).product()
    }

    public func solvePart2() -> Int {
        var boxes: Set<Set<Coordinate>> = Set(coordinates.map { [$0] })
        for pair in pairsSortedByDistances {
            let box1 = boxes.first { $0.contains(pair.0) } ?? []
            boxes.remove(box1)
            let box2 = boxes.first { $0.contains(pair.1) } ?? []
            boxes.remove(box2)
            boxes.insert(box1.union(box2))
            if boxes.count == 1 {
                return pair.0.x * pair.1.x
            }
        }
        return 0
    }
}

private struct Coordinate: Hashable {
    let x: Int
    let y: Int
    let z: Int
    
    func distance(to other: Coordinate) -> Int {
        square(x - other.x) + square(y - other.y) + square(z - other.z)
    }
}

private func square(_ value: Int) -> Int {
    value * value
}
