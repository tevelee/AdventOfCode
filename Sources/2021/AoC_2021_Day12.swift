
public final class AoC_2021_Day12 {
    let neighbors: [String: Set<String>]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        let connections = contents.lines
            .map { $0.split(separator: "-").map(String.init) }
            .map { ($0[0], $0[1]) }
        neighbors = connections.reduce(into: [:]) { result, connection in
            if connection.1 != "start" && connection.0 != "end" {
                result[connection.0, default: []].insert(connection.1)
            }
            if connection.0 != "start" && connection.1 != "end" {
                result[connection.1, default: []].insert(connection.0)
            }
        }
    }

    public func solvePart1() -> Int {
        numberOfTraversals()
    }

    public func solvePart2() -> Int {
        numberOfTraversals(maxVisitsForOne: 2)
    }

    private func numberOfTraversals(from: String = "start", maxVisitsForOne: Int? = nil, smallCavesVisited: [String: Int] = [:]) -> Int {
        guard from != "end" else {
            return 1
        }

        var smallCavesVisited = smallCavesVisited
        if from.isLowercase {
            smallCavesVisited[from, default: 0] += 1
        }

        var count = 0
        for node in neighbors[from, default: []] where canVisit(node, maxVisitsForOne: maxVisitsForOne, smallCavesVisited: smallCavesVisited) {
            count += numberOfTraversals(from: node, maxVisitsForOne: maxVisitsForOne, smallCavesVisited: smallCavesVisited)
        }
        return count
    }

    private func canVisit(_ node: String, maxVisitsForOne: Int?, smallCavesVisited: [String: Int]) -> Bool {
        if let maxVisitsForOne = maxVisitsForOne, !smallCavesVisited.values.contains(maxVisitsForOne) {
            return true
        }
        return smallCavesVisited[node, default: 0] < 1
    }
}

private extension String {
    var isLowercase: Bool {
        allSatisfy(\.isLowercase)
    }
}
