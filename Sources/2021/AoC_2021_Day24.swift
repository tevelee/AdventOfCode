import Algorithms
import Utils

public final class AoC_2021_Day24 {
    private let lines: Lines

    public init(_ inputFileURL: URL) {
        lines = inputFileURL.lines.eraseToAnyAsyncSequence()
    }

    public init(_ input: String) {
        lines = input.lines.async.eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        let rules = try await collectRules()
        let digits = rules.sorted(by: \.key).map { rule -> Int in
            if rule.value.offset > 0 {
                return 9
            } else {
                return 9 + rule.value.offset
            }
        }
        return try await validate(digits)
    }

    public func solvePart2() async throws -> Int {
        let rules = try await collectRules()
        let digits = rules.sorted(by: \.key).map { rule -> Int in
            if rule.value.offset > 0 {
                return 1 + rule.value.offset
            } else {
                return 1
            }
        }
        return try await validate(digits)
    }

    private func validate(_ digits: [Int]) async throws -> Int {
        let outputs = try await run(inputDigits: digits)
        if outputs["z"] == 0, let result = Int(digits.map(String.init).joined(separator: "")) {
            return result
        }
        return 0
    }

    /// Explanation: https://github.com/dphilipson/advent-of-code-2021/blob/master/src/days/day24.rs
    private func collectRules() async throws -> [Int: (index: Int, offset: Int)] {
        let lines = try await lines.collect()
        let variables = lines
            .chunks(ofCount: lines.count / 14)
            .map { original -> (div: String, check: String, offset: String) in
                let lines = Array(original)
                return (div: lines[4].replacingOccurrences(of: "div z ", with: ""),
                        check: lines[5].replacingOccurrences(of: "add x ", with: ""),
                        offset: lines[15].replacingOccurrences(of: "add y ", with: ""))
            }
        var rules: [Int: (index: Int, offset: Int)] = [:]
        var stack: [(index: Int, offset: Int)] = []
        var index = 0
        for variable in variables {
            let check = Int(variable.check)!
            let offset = Int(variable.offset)!
            if check > 0 {
                stack.append((index, offset))
            } else if let last = stack.popLast() {
                let offset = last.offset + check
                rules[index] = (last.index, offset)
                rules[last.index] = (index, -offset)
            }
            index += 1
        }
        return rules
    }

    private func run(inputDigits: [Int]) async throws -> [String: Int] {
        var registers: [String: Int] = [:]
        var inputIndex = 0
        for try await line in lines {
            let components = line.words
            let instruction = components[0]
            let registerName = components[1]
            if instruction == "inp" {
                registers[registerName] = inputDigits[inputIndex]
                inputIndex += 1
            } else {
                let parameter = components[2]
                let registerValue = registers[registerName, default: 0]
                let parameterValue = parameter.first!.isLetter ? registers[parameter, default: 0] : Int(parameter)!
                switch instruction {
                    case "add":
                        registers[registerName] = registerValue + parameterValue
                    case "mul":
                        registers[registerName] = registerValue * parameterValue
                    case "div":
                        registers[registerName] = Int(registerValue / parameterValue)
                    case "mod":
                        registers[registerName] = registerValue % parameterValue
                    case "eql":
                        registers[registerName] = registers[registerName] == parameterValue ? 1 : 0
                    default:
                        fatalError()
                }
            }
        }
        return registers
    }
}
