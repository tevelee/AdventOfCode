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
        LazyGraph<(name: String, numberOfSteps: Int), Empty> { [self] (node: String, numberOfSteps: Int) in
            let instruction = instructions[relativeIndex: numberOfSteps % instructions.count]
            let routing = routes[node]!
            return (instruction == "L" ? routing.left : routing.right, numberOfSteps + 1)
        }
        .searchFirst(from: (start, 0), strategy: .dfs()) {
            condition($0.name)
        }?.numberOfSteps ?? 0
    }
}
