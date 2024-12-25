import Utils

public final class AoC_2024_Day24 {
    private let registers: [String: Value]
    private let instructions: [Instruction]

    public init(_ input: Input) throws {
        let (registers, instructions) = try input.wholeInput.paragraphs.elements()
        self.instructions = instructions.compactMap { line in
            guard let match = line.wholeMatch(of: /(?<lhs>.*) (?<gate>.*) (?<rhs>.*) -> (?<result>.*)/),
                  let gate = Gate(rawValue: String(match.gate).lowercased()) else {
                return nil
            }
            return Instruction(gate: gate, lhs: String(match.lhs), rhs: String(match.rhs), output: String(match.result))
        }
        self.registers = registers.reduce(into: [:]) { output, line in
            guard let match = line.wholeMatch(of: /(?<name>.*): (?<value>[01])/) else { return }
            output[String(match.name)] = .set(match.value == "1")
        } + self.instructions.reduce(into: [:]) { $0[$1.output] = .unset }
    }

    private lazy var xRegisters = registers(prefixed: "x")
    private lazy var yRegisters = registers(prefixed: "y")
    private lazy var zRegisters = registers(prefixed: "z")

    public func solvePart1() -> Int {
        simulate(instructions: instructions, registers: registers)
    }

    private func simulate(instructions: [Instruction], registers: [String: Value]) -> Int {
        var registers = registers
        var last = registers
        while zRegisters.contains(where: { registers[$0] == .unset }) {
            for instruction in instructions {
                if case .set(let lhs) = registers[instruction.lhs], case .set(let rhs) = registers[instruction.rhs] {
                    registers[instruction.output] = .set(instruction.gate.evaluate(lhs, rhs))
                }
            }
            if last == registers {
                return -1
            }
            last = registers
        }
        return value(of: zRegisters, in: registers)
    }

    public func solvePart2() -> String? {
        var instructions = instructions
        var swaps: [String] = []
        for bit in 0 ..< xRegisters.count where !test(bit: bit, using: instructions) {
            let candidates = dependencies(of: nameOfZRegister(at: bit + 1), amongst: instructions) + zRegisters.suffix(bit + 1)
            let swapped = findSwaps(at: bit + 1, amongst: candidates, instructions: &instructions)
            swaps.append(swapped.0)
            swaps.append(swapped.1)
        }
        return swaps.sorted().joined(separator: ",")
    }

    private func test(bit: Int, using instructions: [Instruction]) -> Bool {
        for _ in 1 ... 10 {
            let x = Int.random(in: 0 ... pow(bit, base: 2))
            let y = Int.random(in: 0 ... pow(bit, base: 2))
            var registers = registers
            setValue(x, to: xRegisters, in: &registers)
            setValue(y, to: yRegisters, in: &registers)
            let result = simulate(instructions: instructions, registers: registers)
            if result != x + y {
                return false
            }
        }
        return true
    }

    private func dependencies(of output: String, amongst instructions: [Instruction]) -> Set<String> {
        let producers = instructions.filter { $0.output == output }
        if producers.isEmpty {
            return []
        } else {
            var set = Set<String>()
            for instruction in producers {
                for input in [instruction.lhs, instruction.rhs] {
                    if !input.hasPrefix("x") && !input.hasPrefix("y") {
                        set.insert(input)
                    }
                    set.formUnion(dependencies(of: input, amongst: instructions))
                }
            }
            return set
        }
    }

    private func findSwaps(at bit: Int, amongst candidates: Set<String>, instructions: inout [Instruction]) -> (String, String) {
        for (name1, name2) in candidates.sorted().combinations(ofCount: 2).compactMap({ try? $0.elements() }) {
            let index1 = instructions.firstIndex { $0.output == name1 }!
            let index2 = instructions.firstIndex { $0.output == name2 }!
            instructions[index1].output = name2
            instructions[index2].output = name1
            if test(bit: bit, using: instructions) {
                return (name1, name2)
            }
            instructions[index1].output = name1
            instructions[index2].output = name2
        }
        fatalError()
    }

    private func nameOfZRegister(at bit: Int) -> String {
        "z\(String(format: "%02d", bit))"
    }

    private func registers(prefixed prefix: String) -> [String] {
        registers.keys.filter { $0.hasPrefix(prefix) }.sorted().reversed()
    }

    private func value(of selection: [String], in registers: [String: Value]) -> Int {
        Int(selection.map { registers[$0]?.value == true ? "1" : "0" }.joined(), radix: 2)!
    }

    private func setValue(_ value: Int, to selection: [String], in registers: inout [String: Value]) {
        for name in selection {
            registers[name] = .set(false)
        }
        for (name, value) in zip(selection.reversed(), String(value, radix: 2).reversed()) {
            registers[name] = .set(value == "1")
        }
    }
}

private struct Instruction {
    let gate: Gate
    let lhs: String
    let rhs: String
    var output: String
}

private enum Value: Equatable {
    case unset
    case set(Bool)

    var value: Bool? {
        switch self {
            case .unset: nil
            case .set(let value): value
        }
    }
}

private enum Gate: String {
    case and, or, xor

    func evaluate(_ lhs: Bool, _ rhs: Bool) -> Bool {
        switch self {
        case .and: lhs && rhs
        case .or: lhs || rhs
        case .xor: lhs != rhs
        }
    }
}
