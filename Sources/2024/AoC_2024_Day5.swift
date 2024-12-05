import Algorithms
import Utils

public final class AoC_2024_Day5 {
    private let orderingRules: OrderingRules
    private let updates: [[Int]]

    public init(_ input: Input) throws {
        let (rawRules, rawUpdates) = try input.wholeInput.paragraphs.elements()
        orderingRules = try OrderingRules(rules: rawRules.map { try $0.integers.elements() })
        updates = rawUpdates.map(\.integers)
    }

    private lazy var sortedUpdates = updates.partitioned { update in
        update.combinations(ofCount: 2)
            .compactMap { try? $0.elements() }
            .allSatisfy(orderingRules.isInCorrectOrder)
    }

    public func solvePart1() async throws -> Int {
        sortedUpdates.trueElements
            .sum(of: \.middleElement)
    }

    public func solvePart2() async throws -> Int {
        sortedUpdates.falseElements
            .map { $0.sorted(by: orderingRules.isInCorrectOrder) }
            .sum(of: \.middleElement)
    }
}

private struct OrderingRules {
    let precedences: [Int: Set<Int>]

    init(rules: [(before: Int, after: Int)]) {
        precedences = rules.grouped(by: \.before).mapValues { Set($0.map(\.after)) }
    }

    func isInCorrectOrder(_ first: Int, _ second: Int) -> Bool {
        guard let precedenceRule = precedences[second] else { return true }
        return !precedenceRule.contains(first)
    }
}

private extension Collection where Index == Int {
    var middleElement: Element {
        self[(endIndex - startIndex) / 2]
    }
}
