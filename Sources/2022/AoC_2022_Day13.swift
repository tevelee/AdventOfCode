import RegexBuilder
import Utils

public final class AoC_2022_Day13 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await input.lines
            .nonEmpty()
            .chunks(ofCount: 2)
            .enumerated()
            .filter { try self.isInRightOrder(lhs: $1[0], rhs: $1[1]) }
            .sum { $0.offset + 1 }
    }

    public func solvePart2() async throws -> Int {
        var items = try await input.lines
            .nonEmpty()
            .collect()
            .map(parse)

        let divider1: Node = .composite([.composite([.number(2)])])
        let divider2: Node = .composite([.composite([.number(6)])])
        items.append(divider1)
        items.append(divider2)
        items.sort(by: isInRightOrder)

        guard let index1 = items.firstIndex(of: divider1),
              let index2 = items.firstIndex(of: divider2) else {
            return 0
        }
        return (index1 + 1) * (index2 + 1)
    }

    @Sendable
    private func isInRightOrder(lhs: String, rhs: String) throws -> Bool {
        try isInRightOrder(lhs: parse(lhs), rhs: parse(rhs))
    }

    private func isInRightOrder(lhs: Node, rhs: Node) -> Bool {
        Node.isInRightOrder(lhs: lhs, rhs: rhs) ?? true
    }

    private func parse(_ string: String) throws -> Node {
        try parse(string[...]).node
    }

    private func parse(_ string: Substring) throws -> (node: Node, length: Int) {
        if let int = Int(string) {
            return (.number(int), string.count)
        }
        var scanner = Scanner(string)
        guard scanner.scan("[") else {
            throw ParseError()
        }
        var currentList: [Node] = []
        while !scanner.isFinished {
            if scanner.scan("]") {
                return (.composite(currentList), scanner.scanned)
            } else if let int = scanner.scanInt() {
                currentList.append(.number(int))
            } else {
                let (node, scanned) = try parse(scanner.rest)
                currentList.append(node)
                scanner.consume(scanned)
            }
            scanner.scan(",")
        }
        throw ParseError()
    }
}

private struct ParseError: Error {}

private enum Node: Equatable {
    case number(Int)
    indirect case composite([Node])

    static func isInRightOrder(lhs: Node, rhs: Node) -> Bool? {
        switch (lhs, rhs) {
        case let (.number(lhsValue), .number(rhsValue)) where lhsValue == rhsValue:
            return nil
        case let (.number(lhsValue), .number(rhsValue)):
            return lhsValue < rhsValue
        case (.number, .composite):
            return isInRightOrder(lhs: .composite([lhs]), rhs: rhs)
        case (.composite, .number):
            return isInRightOrder(lhs: lhs, rhs: .composite([rhs]))
        case let (.composite(lhsList), .composite(rhsList)):
            for (lhsChild, rhsChild) in zip(lhsList, rhsList) {
                if let decision = isInRightOrder(lhs: lhsChild, rhs: rhsChild) {
                    return decision
                }
            }
            let lhsSize = lhsList.count
            let rhsSize = rhsList.count
            return lhsSize == rhsSize ? nil : lhsSize < rhsSize
        }
    }
}

private extension AsyncSequence where Element == String {
    func nonEmpty() -> AsyncFilterSequence<Self> {
        filter(!\.isEmpty)
    }
}

private struct Scanner {
    var rest: Substring
    var scanned = 0

    init(_ string: Substring) {
        rest = string
    }

    var isFinished: Bool { rest.isEmpty }

    @discardableResult
    mutating func scanInt() -> Int? {
        guard let match = rest.firstMatch(of: /^(\d+)/), let value = Int(match.output.1) else {
            return nil
        }
        consume(match.output.1.count)
        return value
    }

    @discardableResult
    mutating func scan(_ character: Character) -> Bool {
        guard rest.first == character else {
            return false
        }
        consume(1)
        return true
    }

    mutating func consume(_ count: Int) {
        rest.removeFirst(count)
        scanned += count
    }
}
