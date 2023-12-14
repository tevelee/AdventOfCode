import Algorithms

final class AoC_2023_Day8 {
    private let instructions: String
    private let routes: [String: (left: String, right: String)]

    init(_ input: Input) throws {
        let paragraphs = try input.wholeInput.paragraphs
        guard let (first, rest) = paragraphs.headAndTail else { throw ParseError() }
        self.instructions = first.joined()
        self.routes = Dictionary(uniqueKeysWithValues: rest.joined().compactMap { line in
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
            .reduce(1, lowestCommonMultiple)
    }

    private func solve(start: String, until condition: (String) -> Bool) -> Int {
        var numberOfSteps = 0
        var currentState = start
        repeat {
            let instruction = instructions[numberOfSteps % instructions.count]
            numberOfSteps += 1
            let routing = routes[currentState]!
            if instruction == "L" {
                currentState = routing.left
            } else {
                currentState = routing.right
            }
        } while !condition(currentState)
        return numberOfSteps
    }

    private func lowestCommonMultiple(_ a: Int, _ b: Int) -> Int {
        (a * b) / greatestCommonDivisor(a, b)
    }

    private func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
        var num1 = a
        var num2 = b
        while num2 != 0 {
            let temp = num2
            num2 = num1 % num2
            num1 = temp
        }
        return num1
    }
}
