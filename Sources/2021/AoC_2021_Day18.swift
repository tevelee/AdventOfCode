import Algorithms
import Parsing
import Utils

public final class AoC_2021_Day18 {
    let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ input: String) {
        lines = input.lines.async.eraseToAnyAsyncSequence()
    }

    enum Node: Equatable {
        case number(Int)
        indirect case pair(left: Node, right: Node)
    }

    public func solvePart1() async throws -> Int {
        try await lines.map { self.parse(line: $0) }.reduce(add)!.magnitude
    }

    public func solvePart2() async throws -> Int {
        let values = try await lines.map { self.parse(line: $0) }.collect()
        return product(values, values)
            .lazy
            .filter { $0 != $1 }
            .map(add)
            .map(\.magnitude)
            .max()!
    }

    private func parse(line: String) -> Node {
        try! nodeParser().parse(line)
    }

    private func nodeParser() -> AnyParser<Substring, Node> {
        Parse {
            OneOf {
                Int.parser(of: Substring.self).map(Node.number)
                Parse(Node.pair) {
                    "["
                    Lazy { self.nodeParser() }
                    ","
                    Lazy { self.nodeParser() }
                    "]"
                }
            }
        }.eraseToAnyParser()
    }

    private func add(left: Node, right: Node) -> Node {
        reduce(.pair(left: left, right: right))
    }

    private func reduce(_ node: Node) -> Node {
        var result = node
        while let iteration = result.explode() ?? result.split() {
            result = iteration
        }
        return result
    }
}

extension AoC_2021_Day18.Node: CustomStringConvertible {
    var magnitude: Int {
        switch self {
            case let .number(value):
                return value
            case let .pair(left: left, right: right):
                return left.magnitude * 3 + right.magnitude * 2
        }
    }

    var description: String {
        switch self {
            case let .number(value):
                return String(value)
            case let .pair(left: left, right: right):
                return "(\(left),\(right))"
        }
    }

    func split() -> Self? {
        switch self {
            case let .number(value):
                if value >= 10 {
                    let floor = Int(floor(Double(value) / 2.0))
                    let ceil = Int(ceil(Double(value) / 2.0))
                    return .pair(left: .number(floor), right: .number(ceil))
                } else {
                    return nil
                }
            case let .pair(left: left, right: right):
                if let leftSplit = left.split() {
                    return .pair(left: leftSplit, right: right)
                } else if let rightSplit = right.split() {
                    return .pair(left: left, right: rightSplit)
                } else {
                    return nil
                }
        }
    }

    func explode() -> Self? {
        self.explode(depth: 0)?.value
    }

    private func explode(depth: Int) -> (value: Self, left: Int, right: Int)? {
        if depth >= 4, case let .pair(.number(left), .number(right)) = self {
            return (.number(0), left, right)
        }
        switch self {
            case .number:
                return nil
            case let .pair(left: left, right: right):
                if let explodeLeft = left.explode(depth: depth + 1) {
                    if explodeLeft.right != 0, let rightValue = right.addToLeftMostNumber(explodeLeft.right) {
                        return (.pair(left: explodeLeft.value, right: rightValue), explodeLeft.left, 0)
                    } else {
                        return (.pair(left: explodeLeft.value, right: right), explodeLeft.left, explodeLeft.right)
                    }
                } else if let explodeRight = right.explode(depth: depth + 1) {
                    if explodeRight.left != 0, let leftValue = left.addToRightMostNumber(explodeRight.left) {
                        return (.pair(left: leftValue, right: explodeRight.value), 0, explodeRight.right)
                    } else {
                        return (.pair(left: left, right: explodeRight.value), explodeRight.left, explodeRight.right)
                    }
                } else {
                    return nil
                }
        }
    }

    private func addToLeftMostNumber(_ value: Int) -> Self? {
        switch self {
            case let .pair(left: left, right: right):
                if let result = left.addToLeftMostNumber(value) {
                    return .pair(left: result, right: right)
                }
                return nil
            case let .number(number):
                return .number(number + value)
        }
    }

    private func addToRightMostNumber(_ value: Int) -> Self? {
        switch self {
            case let .pair(left: left, right: right):
                if let result = right.addToRightMostNumber(value) {
                    return .pair(left: left, right: result)
                }
                return nil
            case let .number(number):
                return .number(number + value)
        }
    }
}
