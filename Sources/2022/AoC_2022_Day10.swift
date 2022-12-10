import RegexBuilder
import Utils

public final class AoC_2022_Day10 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await streamOfCycles().reduce(into: 0) { signalStrength, cycle in
            if (cycle.numberOfIterationsCompleted - 20).isMultiple(of: 40) {
                signalStrength += cycle.numberOfIterationsCompleted * cycle.registerValue
            }
        }
    }

    public func solvePart2() async throws -> String {
        var screen: String = ""
        for try await (numberOfIterationsCompleted, sprite) in streamOfCycles() {
            let output = (sprite...(sprite + 2)).contains(numberOfIterationsCompleted % 40) ? "#" : "."
            screen += output
            if numberOfIterationsCompleted.isMultiple(of: 40) {
                screen += "\n"
            }
        }
        return parseCharacters(on: screen)
    }

    private func runCycles(tick: (Int, Int) -> Void) async throws {
        var registerValue = 1
        var numberOfIterationsCompleted = 0
        for try await line in input.lines {
            let instruction = try Instruction(rawValue: line)
            switch instruction {
            case .noop:
                numberOfIterationsCompleted += 1
                tick(numberOfIterationsCompleted, registerValue)
            case .addX(let value):
                numberOfIterationsCompleted += 1
                tick(numberOfIterationsCompleted, registerValue)
                numberOfIterationsCompleted += 1
                tick(numberOfIterationsCompleted, registerValue)
                registerValue += value
            }
        }
    }

    private func streamOfCycles() -> AsyncThrowingStream<(numberOfIterationsCompleted: Int, registerValue: Int), Error> {
        .init { continuation in
            let task = Task {
                do {
                    try await self.runCycles {
                        continuation.yield(($0, $1))
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { reason in
                if case .cancelled = reason {
                    task.cancel()
                }
            }
        }
    }

    private func parseCharacters(on screen: String, padding: Int = 1) -> String {
        String((0..<8).map { index in
            characters4x6[character(at: index, on: screen)] ?? "?"
        })
    }

    private func character(at index: Int, on screen: String, width: Int = 4, padding: Int = 1) -> String {
        screen.lines.map { line in
            String((0 ..< width).compactMap { x in
                line[(index * (width + padding)) + x]
            })
        }.joined(separator: "\n")
    }
}

private struct ParseError: Error {}

private enum Instruction {
    case noop
    case addX(Int)

    init(rawValue: String) throws {
        let regex = Regex {
            ChoiceOf {
                Capture {
                    "noop"
                } transform: { _ in
                    Instruction.noop
                }
                Regex {
                    "addx "
                    Capture {
                        Integer()
                    } transform: { value in
                        Instruction.addX(value)
                    }
                }
            }
        }
        guard let output = rawValue.wholeMatch(of: regex)?.output, let value = output.1 ?? output.2 else {
            throw ParseError()
        }
        self = value
    }
}
