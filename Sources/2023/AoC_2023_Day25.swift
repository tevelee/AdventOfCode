import Utils

final class AoC_2023_Day25 {
    private let first: String
    private let connections: [String: Set<String>]

    init(_ input: Input) throws {
        var connections: [String: Set<String>] = [:]
        var first: String = ""
        for line in try input.wholeInput.lines {
            let segments = line.split(separator: ":")
            let origin = String(segments[0])

            if connections.isEmpty { first = origin }

            let destinations = Set(segments[1].split(separator: " ").map(String.init))
            connections[origin, default: []] += destinations
            for node in destinations {
                connections[node, default: []] += origin
            }
        }
        (self.first, self.connections) = (first, connections)
    }

    func solve() -> Int {
        for key in connections.keys.shuffled() {
            let residualGraph = fordFulkerson(
                connections: connections,
                source: first,
                sink: key
            ).residualGraph
            let cutEdges = findCutEdges(connections: connections, residualGraph: residualGraph, source: first)
            guard cutEdges.count == 3 else { continue }
            let count = size(of: residualGraph, source: first)
            return count * (residualGraph.count - count)
        }
        return 0
    }

    private func fordFulkerson(
        connections: [String: Set<String>],
        source: String,
        sink: String
    ) -> (maxFlowAndMinCut: Int, residualGraph: [String: Set<String>]) {
        var graph = connections

        var maxFlow = 0
        var parentMap: [String: String] = [:]

        while isReachable(sink, from: source, in: graph, parentMap: &parentMap) {
            var pathFlow = Int.max
            var s = sink
            while s != source {
                let pred = parentMap[s]!
                pathFlow = min(pathFlow, graph[pred]?.contains(s) ?? false ? 1 : 0)
                s = pred
            }

            s = sink
            while s != source {
                let pred = parentMap[s]!
                graph[pred]?.remove(s)
                graph[s]?.insert(pred)
                s = pred
            }

            maxFlow = maxFlow &+ pathFlow
        }

        return (maxFlow, graph)
    }

    private func size(of graph: [String: Set<String>], source: String) -> Int {
        var count = 0
        _ = search(start: source) {
            DFS().unique
        } goal: { _ in
            count += 1
            return false
        } next: {
            graph[$0]!
        }
        return count
    }

    private func isReachable(
        _ sink: String,
        from source: String,
        in graph: [String: Set<String>],
        parentMap: inout [String: String]
    ) -> Bool {
        parentMap[source] = source
        return search(start: (node: source, previous: String?.none)) {
            BFS().unique(by: \.node)
        } goal: { node, previous in
            parentMap[node] = previous
            return node == sink
        } next: { node, _ in
            graph[node]!.map { ($0, node) }
        } != nil
    }

    private func findCutEdges(
        connections: [String: Set<String>],
        residualGraph: [String: Set<String>],
        source: String
    ) -> [(String, String)] {
        var visited = Set<String>()
        var stack = [source]
        visited.insert(source)

        while let u = stack.popLast() {
            if let neighbors = residualGraph[u] {
                for v in neighbors {
                    if !visited.contains(v) {
                        visited.insert(v)
                        stack.append(v)
                    }
                }
            }
        }

        var minCutEdges = [(String, String)]()
        for (u, neighbors) in connections {
            for v in neighbors {
                if visited.contains(u) && !visited.contains(v) {
                    minCutEdges.append((u, v))
                }
            }
        }

        return minCutEdges
    }
}
