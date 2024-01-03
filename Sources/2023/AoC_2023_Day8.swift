import Algorithms
import Utils

final class AoC_2023_Day8 {
    private let instructions: String
    private let routes: [String: (left: String, right: String)]

    init(_ input: Input) throws {
        let (first, last) = try input.wholeInput.paragraphs.elements()
        self.instructions = first.joined()
        self.routes = Dictionary(uniqueKeysWithValues: last.compactMap { line in
            guard let match = line.firstMatch(of: /(?<origin>.*?) = \((?<left>.*?), (?<right>.*?)\)/)?.output else {
                return nil
            }
            return (String(match.origin), (String(match.left), String(match.right)))
        })
    }

    func solvePart1() -> Int {
        solve(start: "AAA") { $0 == "ZZZ" }
    }

    func solvePart2() -> Int {
        routes.keys
            .filter { $0.last == "A" }
            .map { solve(start: $0) { $0.last == "Z" } }
            .lowestCommonMultiple()
    }

    private func solve(start: String, until condition: @escaping (String) -> Bool) -> Int {
        Search {
            DFS()
        } traversal: {
            Traversal(start: (node: start, numberOfSteps: 0)) { [self] node, numberOfSteps in
                let instruction = instructions[numberOfSteps % instructions.count]
                let routing = routes[node]!
                return (instruction == "L" ? routing.left : routing.right, numberOfSteps + 1)
            }
            .goal { condition($0.node) }
        }
        .run()?.numberOfSteps ?? 0
    }
}
