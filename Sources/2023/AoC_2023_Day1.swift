final class AoC_2023_Day1: Day {
    let input: Input

    init(_ input: Input) {
        self.input = input
    }
    
    private lazy var digitValues = (1...9).keyed(by: String.init)
    private lazy var spelledOutValues = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return (1...9).keyed(by: formatter.format)
    }()

    func solvePart1() async throws -> Int {
        try await sumNumbers(digitValues)
    }

    func solvePart2() async throws -> Int {
        try await sumNumbers(digitValues + spelledOutValues)
    }

    private func sumNumbers(_ valuesOfDigitRepresentations: [String: Int]) async throws -> Int {
        let valuesOfReversedDigitRepresentations = valuesOfDigitRepresentations.mapKeys { $0.reversed() }
        return try await input.lines.sum { line in
            let firstDigit = valueOfFirstMatchingDigit(in: line, values: valuesOfDigitRepresentations)
            let lastDigit = valueOfFirstMatchingDigit(in: line.reversed(), values: valuesOfReversedDigitRepresentations)
            return firstDigit * 10 + lastDigit
        }
    }

    private func valueOfFirstMatchingDigit(
        in sourceString: some Collection<Character>,
        values: [some Collection<Character>: Int]
    ) -> Int {
        (0...sourceString.count).firstNonNil { startIndex in
            values.keys.first(where: sourceString.dropFirst(startIndex).hasPrefix)
        }.flatMap { values[$0] } ?? 0
    }
}

private extension NumberFormatter {
    func format(number: Int) -> String {
        string(from: number as NSNumber) ?? ""
    }
}
