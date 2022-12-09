import RegexBuilder
import Utils

public final class AoC_2022_Day5 {
    private let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> String {
        let (stacks, instructions) = try parseInput()
        return stacks.applying(instructions.flatMap(\.flattened)).topLetters()
    }

    public func solvePart2() throws -> String {
        let (stacks, instructions) = try parseInput()
        return stacks.applying(instructions).topLetters()
    }

    private func parseInput() throws -> (Stacks, [Instruction]) {
        let paragraphs = try input.wholeInput.paragraphs
        guard let stacksParagraph = paragraphs.first,
              let instructionsParagraph = paragraphs.last else {
            throw ParsingError()
        }
        let stacks = try Stacks(parsing: stacksParagraph)
        let instructions = try instructionsParagraph.compactMap(Instruction.init)
        return (stacks, instructions)
    }
}

private struct ParsingError: Error {}

private struct Stacks {
    private var storage: [Int: [Character]]

    init(parsing lines: [String]) throws {
        guard let lastLine = lines.last else {
            throw ParsingError()
        }
        storage = Dictionary(grouping: lastLine.matches(of: /\d+/).map(\.range)) { Int(lastLine[$0])! }
            .compactMapValues(\.first)
            .mapValues { range in
                lines.dropLast(1)
                    .reversed()
                    .compactMap { line in
                        range.lowerBound < line.endIndex ? line[range.lowerBound] : nil
                    }
                    .filter { $0 != " " }
            }
    }

    private mutating func apply(_ instruction: Instruction) {
        if let characters = storage[instruction.origin]?.popLast(instruction.count) {
            storage[instruction.destination]?.append(contentsOf: characters)
        }
    }

    func applying(_ instructions: [Instruction]) -> Self {
        var result = self
        for instruction in instructions {
            result.apply(instruction)
        }
        return result
    }

    func topLetters() -> String {
        String(storage.keys.sorted().compactMap { storage[$0]?.last })
    }
}

private struct Instruction {
    let count: Int
    let origin: Int
    let destination: Int

    var flattened: [Instruction] {
        Array(repeating: Instruction(count: 1, origin: origin, destination: destination), count: count)
    }
}

private extension Instruction {
    init(parsing line: String) throws {
        let count = Reference<Int>()
        let origin = Reference<Int>()
        let destination = Reference<Int>()
        let regex = Regex {
            "move "
            Capture(.integer, as: count)
            " from "
            Capture(.integer, as: origin)
            " to "
            Capture(.integer, as: destination)
        }

        guard let values = try regex.wholeMatch(in: line) else {
            throw ParsingError()
        }
        self.count = values[count]
        self.origin = values[origin]
        self.destination = values[destination]
    }
}

private extension Array {
    mutating func popLast(_ n: Int) -> ArraySlice<Element> {
        let removed = self[(count - n)...]
        removeLast(n)
        return removed
    }
}
