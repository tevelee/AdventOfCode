import Utils

public final class AoC_2024_Day17 {
    private let registers: Registers
    private let rawProgram: [Int]
    private let program: [(Instruction, Operand)]

    public init(_ input: Input) throws {
        let regex = #/
        Register\ A:\ (?<a>\d+)\n
        Register\ B:\ (?<b>\d+)\n
        Register\ C:\ (?<c>\d+)\n
        \n
        Program:\ (?<program>.+)\n?
        /#
        guard let match = try input.wholeInput.wholeMatch(of: regex),
            let a = Int(match.a), let b = Int(match.b), let c = Int(match.c) else { throw ParseError() }
        registers = Registers(a: a, b: b, c: c)
        rawProgram = match.program.integers
        program = try match.program.matches(of: /(?<opcode>\d),(?<operand>\d),?/).map { match in
            guard let opcode = UInt8(match.opcode),
                  let instruction = Instruction(rawValue: opcode),
                  let operand = UInt8(match.operand) else { throw ParseError() }
            return (instruction, Operand(operand, isLiteral: instruction.hasLiteralOperand))
        }
    }

    public func solvePart1() -> String {
        run(using: registers).map(String.init).joined(separator: ",")
    }

    public func solvePart2() -> Int {
        var value = 0
        repeat {
            for offset in 0... {
                let newValue = value * 8 + offset
                let output = run(overridingRegisterA: newValue)
                if rawProgram.hasSuffix(output) {
                    value = newValue
                    break
                }
            }
        } while rawProgram != run(overridingRegisterA: value)
        return value
    }

    private func run(overridingRegisterA value: Int) -> [Int] {
        run(using: registers.overriding(a: value))
    }

    private func run(using registers: Registers) -> [Int] {
        var registers = registers
        var cursor = 0
        var result: [Int] = []
        while cursor < program.count {
            let (instruction, operand) = program[cursor]
            if let output = instruction.perform(operand: operand, registers: &registers, cursor: &cursor) {
                result.append(output)
            }
            cursor += 1
        }
        return result
    }
}

private struct Registers {
    var a,b,c: Int

    func overriding(a: Int) -> Registers {
        Registers(a: a, b: b, c: c)
    }
}

private enum Instruction: UInt8 {
    case adv
    case bxl
    case bst
    case jnz
    case bxc
    case out
    case bdv
    case cdv

    var hasLiteralOperand: Bool {
        switch self {
            case .bxl, .jnz, .bxc: true
            default: false
        }
    }

    func perform(operand: Operand, registers: inout Registers, cursor: inout Int) -> Int? {
        let operandValue = operand.value(registers: registers)
        switch self {
            case .adv: registers.a /= pow(operandValue, base: 2)
            case .bxl: registers.b ^= operandValue
            case .bst: registers.b = operandValue % 8
            case .jnz: if registers.a != 0 { cursor = operandValue / 2 - 1 }
            case .bxc: registers.b = registers.b ^ registers.c
            case .out: return operandValue % 8
            case .bdv: registers.b = registers.a / pow(operandValue, base: 2)
            case .cdv: registers.c = registers.a / pow(operandValue, base: 2)
        }
        return nil
    }
}

private enum Operand {
    case value(UInt8)
    case register(KeyPath<Registers, Int>)

    init(_ value: UInt8, isLiteral: Bool) {
        switch (isLiteral, value) {
            case (false, 4): self = .register(\.a)
            case (false, 5): self = .register(\.b)
            case (false, 6): self = .register(\.c)
            default: self = .value(value)
        }
    }

    func value(registers: Registers) -> Int {
        switch self {
            case .value(let value): return Int(value)
            case .register(let keyPath): return registers[keyPath: keyPath]
        }
    }
}

private extension Sequence where Element: Equatable {
    func hasSuffix(_ other: some Sequence<Element>) -> Bool {
        reversed().hasPrefix(other.reversed())
    }
}
