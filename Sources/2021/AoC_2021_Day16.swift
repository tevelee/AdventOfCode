import Algorithms

public final class AoC_2021_Day16 {
    private let input: String

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        self.input = input
    }

    enum Operator: Int {
        case sum = 0
        case product = 1
        case min = 2
        case max = 3
        case greaterThan = 5
        case lessThan = 6
        case equalTo = 7
    }

    enum Value {
        case literal(version: Int, value: Int)
        indirect case `operator`(type: Operator, version: Int, content: [Value])

        var version: Int {
            switch self {
                case let .literal(version, _):
                    return version
                case let .`operator`(_, version, content):
                    return content.map(\.version).reduce(version, +)
            }
        }

        var evaluate: Int {
            switch self {
                case let .literal(_, value):
                    return value
                case let .`operator`(.sum, _, content):
                    return content.map(\.evaluate).sum()
                case let .`operator`(.product, _, content):
                    return content.map(\.evaluate).product()
                case let .`operator`(.min, _, content):
                    return content.map(\.evaluate).min() ?? 0
                case let .`operator`(.max, _, content):
                    return content.map(\.evaluate).max() ?? 0
                case let .`operator`(.greaterThan, _, content):
                    return content[0].evaluate > content[1].evaluate ? 1 : 0
                case let .`operator`(.lessThan, _, content):
                    return content[0].evaluate < content[1].evaluate ? 1 : 0
                case let .`operator`(.equalTo, _, content):
                    return content[0].evaluate == content[1].evaluate ? 1 : 0
            }
        }
    }

    public func solvePart1() -> Int {
        parse().version
    }

    public func solvePart2() -> Int {
        parse().evaluate
    }

    private func parse() -> Value {
        let binary = input
            .compactMap(\.hexDigitValue)
            .map { String($0, radix: 2, uppercase: false) }
            .map { $0.leftPadding(toLength: 4, withPad:"0") }
            .flatMap { $0 }
        let result = parse(Substring(binary))
        return result.value
    }

    private func parse(_ input: Substring) -> (value: Value, remainder: Substring) {
        var input = input
        let version = input.scan(3).binary
        let id = input.scan(3).binary

        if id == 4 {
            var result = ""
            var isLast = false
            repeat {
                isLast = input.first == "0"
                result += input.scan(5).suffix(4)
            } while !isLast
            return (.literal(version: version, value: result.binary), input)
        } else {
            let typeID = input.scan(1)
            let condition: () -> Bool
            var subpackets: [Value] = []

            if typeID == "0" {
                let bodyLength = input.scan(15).binary
                let finalLength = input.count - bodyLength
                condition = { input.count > finalLength }
            } else {
                let packetCount = input.scan(11).binary
                condition = { subpackets.count < packetCount }
            }

            while condition() {
                let result = parse(input)
                subpackets.append(result.value)
                input = result.remainder
            }

            return (.operator(type: Operator(rawValue: id)!, version: version, content: subpackets), input)
        }
    }
}

private extension Substring {
    mutating func scan(_ length: Int) -> Substring {
        let value = prefix(length)
        removeFirst(length)
        return value
    }
}

private extension StringProtocol {
    var binary: Int {
        Int(self, radix: 2) ?? 0
    }
}

private extension String {
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > count else { return self }
        let padding = String(repeating: withPad, count: toLength - count)
        return padding + self
    }
}
