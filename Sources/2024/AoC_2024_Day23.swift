import Graphs
import Utils

public final class AoC_2024_Day23 {
    private let connections: [String: Set<String>]

    public init(_ input: Input) throws {
        var connections: [String: Set<String>] = [:]
        for line in try input.wholeInput.lines {
            let (origin, destination) = try line.components(separatedBy: "-").elements()
            connections[origin, default: []].insert(destination)
            connections[destination, default: []].insert(origin)
        }
        self.connections = connections
    }

    public func solvePart1() -> Int {
        var triplets: Set<Set<String>> = []
        for (one, neighbors) in connections {
            for two in neighbors {
                for three in connections[two]! where connections[three]!.contains(one) {
                    triplets.insert([one, two, three])
                }
            }
        }
        return triplets.count {
            $0.contains {
                $0.hasPrefix("t")
            }
        }
    }

    public func solvePart2() -> String {
        var cliques: Set<Set<String>> = []
        runBronKerbosch(p: Set(connections.keys), cliques: &cliques)
        return cliques.max(by: \.count)?.sorted().joined(separator: ",") ?? ""
    }

    private func runBronKerbosch(
        r: Set<String> = [],
        p: Set<String>,
        x: Set<String> = [],
        cliques: inout Set<Set<String>>
    ) {
        if p.isEmpty, x.isEmpty {
            cliques.insert(r)
            return
        }
        var currentP = p
        var currentX = x
        for v in p {
            let neighbors = connections[v]!
            runBronKerbosch(
                r: r.union([v]),
                p: currentP.intersection(neighbors),
                x: currentX.intersection(neighbors),
                cliques: &cliques
            )
            currentP.remove(v)
            currentX.insert(v)
        }
    }
}
