import Utils

public final class AoC_2025_Day8 {
    private let coordinates: [Coordinate]

    public init(_ input: Input) throws {
        coordinates = try input.wholeInput.lines
            .map { try $0.integers.elements() }
            .map(Coordinate.init)
    }

    private lazy var pairsSortedByDistances: some Sequence<(Int, Int)> = {
        var pairs: [(distance: Int, pair: (Int, Int))] = []
        for i in coordinates.indices {
            for j in coordinates.indices.dropFirst(i + 1) {
                let dist = coordinates[i].distance(to: coordinates[j])
                pairs.append((dist, (i, j)))
            }
        }
        pairs.sort { $0.distance < $1.distance }
        return pairs.lazy.map(\.pair)
    }()
    
    private lazy var connections: some Sequence<(unionFind: UnionFind, connection: (Int, Int))> = AnySequence {
        var uf = UnionFind()
        uf.insert(self.coordinates.indices)
        var iterator = self.pairsSortedByDistances.makeIterator()
        return AnyIterator { () -> (unionFind: UnionFind, connection: (Int, Int))? in
            guard let pair = iterator.next() else { return nil }
            uf.union(pair.0, pair.1)
            return (uf, pair)
        }
    }

    public func solvePart1(until limit: Int) -> Int {
        let sets = connections.dropFirst(limit - 1).first!.unionFind.sets()
        return sets.map(\.count).max(count: 3).product()
    }

    public func solvePart2() -> Int {
        let (i, j) = connections.first { $0.unionFind.sets().count == 1 }!.connection
        return coordinates[i].x * coordinates[j].x
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

private struct UnionFind {
    private var parent: [Int]
    private var size: [Int]

    init() {
        self.parent = []
        self.size = []
    }

    mutating func insert(_ values: some Collection<Int>) {
        let count = values.count
        parent += values
        size += Array(repeating: 1, count: count)
    }
    
    mutating func insert(_ value: Int) {
        parent.append(value)
        size.append(1)
    }

    func find(_ x: Int) -> Int {
        var current = x
        var p = parent[current]
        while p != current {
            current = p
            p = parent[current]
        }
        return current
    }

    mutating func findWithPathCompression(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = findWithPathCompression(parent[x])
        }
        return parent[x]
    }

    mutating func union(_ x: Int, _ y: Int) {
        let fx = findWithPathCompression(x)
        let fy = findWithPathCompression(y)
        guard fx != fy else { return }
        if size[fx] < size[fy] {
            parent[fx] = fy
            size[fy] += size[fx]
        } else {
            parent[fy] = fx
            size[fx] += size[fy]
        }
    }
}

extension UnionFind {
    func sets() -> some Collection<[Int]> {
        parent.indices.grouped(by: find).values
    }
}
