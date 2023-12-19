import Algorithms
import Utils

final class AoC_2023_Day19 {
    private var workflows: [String: Workflow]
    private let ratings: [Rating]

    init(_ input: Input) throws {
        let paragraphs = try input.wholeInput.paragraphs
        workflows = try paragraphs[0].map(Workflow.init).keyed(by: \.name)
        ratings = paragraphs[1].map(Rating.init)

        eliminateRedundantRules(in: &workflows)
    }

    func solvePart1() -> Int {
        ratings
            .filter { isAccepted(rating: $0) }
            .sum { $0.x + $0.m + $0.a + $0.s }
    }

    func solvePart2() -> Int {
        acceptableRanges(within: Ranges(all: 1...4000)).sum(of: \.numberOfCombinations)
    }

    private func isAccepted(rating: Rating, for workflowName: String = "in") -> Bool {
        guard let workflow = workflows[workflowName] else { return false }
        let decision = workflow.rules.first { $0.evaluate(rating) }!.decision
        return switch decision {
        case .accept: true
        case .reject: false
        case .redirect(let name): isAccepted(rating: rating, for: name)
        }
    }

    private func acceptableRanges(in workflow: String = "in", within ranges: Ranges) -> [Ranges] {
        acceptableRanges(rules: workflows[workflow]!.rules, within: ranges)
    }

    private func acceptableRanges(rules: [Rule], within ranges: Ranges) -> [Ranges] {
        var result: [Ranges] = []

        var rules = rules
        let rule = rules.removeFirst()

        if let condition = rule.condition {
            result += acceptableRanges(rule: rule, within: condition.operation == .lessThan
                ? ranges.updated(condition.property) { $0.lowerBound ... condition.value - 1 }
                : ranges.updated(condition.property) { condition.value + 1 ... $0.upperBound }
            )
            result += acceptableRanges(rules: rules, within: condition.operation == .lessThan
                ? ranges.updated(condition.property) { condition.value ... $0.upperBound }
                : ranges.updated(condition.property) { $0.lowerBound ... condition.value }
            )
        } else {
            result += acceptableRanges(rule: rule, within: ranges)
        }
        return result
    }

    private func acceptableRanges(rule: Rule, within ranges: Ranges) -> [Ranges] {
        switch rule.decision {
        case .accept:
            [ranges]
        case .redirect(let name):
            acceptableRanges(in: name, within: ranges)
        case .reject:
            []
        }
    }

    private func eliminateRedundantRules(in workflows: inout [String: Workflow]) {
        let redundant = redundantWorkflows(workflows)
        if redundant.isEmpty { return }
        for workflow in redundant {
            let name = workflow.name
            let decision = workflow.rules[0].decision
            for workflow in workflows.values {
                for (offset, rule) in workflow.rules.enumerated() where rule.decision == .redirect(name) {
                    workflows[workflow.name]?.rules[offset].decision = decision
                }
            }
            workflows[workflow.name] = nil
        }
        eliminateRedundantRules(in: &workflows)
    }

    private func redundantWorkflows(_ workflows: [String : Workflow]) -> [Workflow] {
        workflows.values.filter { workflow in
            workflow.rules.allSatisfy { $0.decision == workflow.rules[0].decision }
        }
    }
}

private struct Rating {
    let x, m, a, s: Int
}

extension Rating {
    init(rawString: String) {
        let values = rawString.integers
        x = values[0]
        m = values[1]
        a = values[2]
        s = values[3]
    }
}

private struct Workflow {
    let name: String
    var rules: [Rule]

    init(rawString: String) throws {
        guard let output = rawString.firstMatch(of: /(?<name>.*){(?<rules>.*)}/)?.output else { throw ParseError() }
        name = String(output.name)
        rules = output.rules.split(separator: ",").map(String.init).map(Rule.init)
    }
}

private struct Rule {
    var condition: Condition?
    var decision: Decision

    func evaluate(_ rating: Rating) -> Bool {
        condition?.evaluate(rating) ?? true
    }
}

private struct Condition {
    let property: Character
    var operation: Operation
    let value: Int

    func evaluate(_ rating: Rating) -> Bool {
        let propertyValue: Int? = switch property {
        case "x": rating.x
        case "m": rating.m
        case "a": rating.a
        case "s": rating.s
        default: nil
        }
        guard let propertyValue = propertyValue else { return false }
        return switch operation {
        case .lessThan: propertyValue < value
        case .greaterThan: propertyValue > value
        }
    }
}

private enum Operation: Character {
    case lessThan = "<"
    case greaterThan = ">"
}

private enum Decision: Equatable {
    case accept
    case reject
    case redirect(String)

    init(rawString: String) {
        switch rawString {
        case "R": self = .reject
        case "A": self = .accept
        default: self = .redirect(rawString)
        }
    }
}

extension Rule {
    init(rawString: String) {
        if let output = rawString.firstMatch(of: /(?<property>[xmas])(?<operation>[<>])(?<value>\d+):(?<decision>R|A|.*)/)?.output,
           let property = output.property.first,
           let operation = output.operation.first,
           let operation = Operation(rawValue: operation),
           let value = Int(output.value) {
            condition = Condition(property: property, operation: operation, value: value)
            decision = Decision(rawString: String(output.decision))
        } else {
            condition = nil
            decision = Decision(rawString: rawString)
        }
    }
}

private struct Ranges {
    var x, m, a, s: ClosedRange<Int>

    init(all range: ClosedRange<Int>) {
        x = range
        m = range
        a = range
        s = range
    }

    var numberOfCombinations: Int { x.count * m.count * a.count * s.count }

    func updated(_ character: Character, with block: (ClosedRange<Int>) -> ClosedRange<Int>) -> Ranges {
        var copy = self
        switch character {
        case "x": copy.x = block(copy.x)
        case "m": copy.m = block(copy.m)
        case "a": copy.a = block(copy.a)
        case "s": copy.s = block(copy.s)
        default: fatalError()
        }
        return copy
    }
}
