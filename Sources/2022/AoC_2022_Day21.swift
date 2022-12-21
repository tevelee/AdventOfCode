import Utils

public final class AoC_2022_Day21 {
    private let node: Node

    public init(_ input: Input) throws {
        let entries = try parseEntries(input.wholeInput.lines)
        node = try parseNode(from: entries, origin: "root")
    }

    public func solvePart1() -> Int {
        node.value
    }

    public func solvePart2() -> Int {
        let result = node.solveEquality(for: "humn")

        if case let .operation(_, _, lhs, rhs) = node.replaceNode(named: "humn", with: .number(name: "humn", value: result)) {
            precondition(lhs.value == rhs.value)
        }

        return result
    }
}

private func parseEntries(_ lines: some Sequence<String>) throws -> [String: Entry] {
    var entries: [String: Entry] = [:]
    let number = /(?<name>\w+): (?<value>\d+)/
    let operation = /(?<name>\w+): (?<lhs>\w+) (?<operation>.) (?<rhs>\w+)/
    for line in lines {
        if let output = line.wholeMatch(of: number)?.output, let value = Int(output.value) {
            let name = String(output.name)
            entries[name] = .number(name: name, value: value)
        } else if let output = line.wholeMatch(of: operation)?.output, let operation = output.operation.first {
            let name = String(output.name)
            entries[name] = .operation(name: name, operation: operation, lhs: String(output.lhs), rhs: String(output.rhs))
        } else {
            throw ParseError()
        }
    }
    return entries
}

private func parseNode(from entries: [String: Entry], origin: String) throws -> Node {
    switch entries[origin] {
    case let .number(name, value):
        return .number(name: name, value: value)
    case let .operation(name, character, lhs, rhs):
        return try .operation(name: name,
                              operation: Operation(from: character),
                              lhs: parseNode(from: entries, origin: lhs),
                              rhs: parseNode(from: entries, origin: rhs))
    default:
        throw ParseError()
    }
}

private struct ParseError: Error {}

private enum Entry {
    case number(name: String, value: Int)
    case operation(name: String, operation: Character, lhs: String, rhs: String)
}

private struct Operation {
    let perform: (Int, Int) -> Int
    let inverse: (Int, Int) -> Int
    let isCommutative: Bool

    static let addition = Operation(perform: +, inverse: -, isCommutative: true)
    static let subtraction = Operation(perform: -, inverse: +, isCommutative: false)
    static let multiplication = Operation(perform: *, inverse: /, isCommutative: true)
    static let division = Operation(perform: /, inverse: *, isCommutative: false)
}

private extension Operation {
    init(from character: Character) throws {
        switch character {
        case "+": self = .addition
        case "-": self = .subtraction
        case "*": self = .multiplication
        case "/": self = .division
        default: throw ParseError()
        }
    }
}

private enum Node {
    case number(name: String, value: Int)
    indirect case operation(name: String, operation: Operation, lhs: Node, rhs: Node)

    var value: Int {
        switch self {
        case let .number(_, value):
            return value
        case let .operation(_, operation, lhs, rhs):
            return operation.perform(lhs.value, rhs.value)
        }
    }

    var name: String {
        switch self {
        case let .number(name, _):
            return name
        case let .operation(name, _, _, _):
            return name
        }
    }

    func hasNode(named name: String) -> Bool {
        switch self {
        case .number(name, _), .operation(name, _, _, _):
            return true
        case .number:
            return false
        case let .operation(_, _, lhs, rhs):
            return lhs.hasNode(named: name) || rhs.hasNode(named: name)
        }
    }

    func solveEquality(for nodeToSolve: String) -> Int {
        if case let .operation(_, _, lhs, rhs) = self {
            if lhs.hasNode(named: nodeToSolve) {
                return lhs.findValue(forChildNodeNamed: nodeToSolve, toBeEqualTo: rhs.value)
            }
            if rhs.hasNode(named: nodeToSolve) {
                return rhs.findValue(forChildNodeNamed: nodeToSolve, toBeEqualTo: lhs.value)
            }
        }
        return value
    }

    func findValue(forChildNodeNamed name: String, toBeEqualTo value: Int) -> Int {
        if self.name == name {
            return value
        }
        if case let .operation(_, operation, lhs, rhs) = self {
            if lhs.hasNode(named: name) {
                // x + 3 = 5 // 5 - 3
                // x - 3 = 5 // 5 + 3
                return lhs.findValue(forChildNodeNamed: name, toBeEqualTo: operation.inverse(value, rhs.value))
            } else if operation.isCommutative {
                // 3 + x = 5  -> 5 - 2
                return rhs.findValue(forChildNodeNamed: name, toBeEqualTo: operation.inverse(value, lhs.value))
            } else {
                // 13 - x = 5 -> 13 - 5
                return rhs.findValue(forChildNodeNamed: name, toBeEqualTo: operation.perform(lhs.value, value))
            }
        }
        fatalError()
    }

    func replaceNode(named nodeNameToReplace: String, with node: Node) -> Node {
        if name == nodeNameToReplace {
            return node
        }
        if case let .operation(name, operation, lhs, rhs) = self {
            return .operation(name: name,
                              operation: operation,
                              lhs: lhs.replaceNode(named: nodeNameToReplace, with: node),
                              rhs: rhs.replaceNode(named: nodeNameToReplace, with: node))
        }
        return self
    }
}
