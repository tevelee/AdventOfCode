private import Algorithms
import Utils
import Graphs

public final class AoC_2023_Day8 {
    private let instructions: String
    private let routes: [String: (left: String, right: String)]

    public init(_ input: Input) throws {
        let (first, last) = try input.wholeInput.paragraphs.elements()
        self.instructions = first.joined()
        self.routes = Dictionary(uniqueKeysWithValues: last.compactMap { line in
            guard let match = line.firstMatch(of: /(?<origin>.*?) = \((?<left>.*?), (?<right>.*?)\)/)?.output else {
                return nil
            }
            return (String(match.origin), (String(match.left), String(match.right)))
        })
    }

    public func solvePart1() -> Int {
        solve(start: "AAA") { $0 == "ZZZ" }
    }

    public func solvePart2() -> Int {
        routes.keys
            .filter { $0.last == "A" }
            .map { solve(start: $0) { $0.last == "Z" } }
            .lowestCommonMultiple()
    }

    private func solve(start: String, until condition: @escaping (String) -> Bool) -> Int {
        struct Vertex: Hashable {
            let node: String
            let numberOfSteps: Int
        }
        return LazyIncidenceGraph(neighbors: { [self] vertex in
            let instruction = instructions[relativeIndex: vertex.numberOfSteps % instructions.count]
            let routing = routes[vertex.node]!
            return [
                Vertex(node: instruction == "L" ? routing.left : routing.right, numberOfSteps: vertex.numberOfSteps + 1)
            ]
        })
        .search(from: Vertex(node: start, numberOfSteps: 0), using: .dfs())
        .first { condition($0.currentVertex.node) }?
        .currentVertex.numberOfSteps ?? 0
    }
}
