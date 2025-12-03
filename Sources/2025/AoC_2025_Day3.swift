import Utils

public final class AoC_2025_Day3 {
    private let banks: AnyAsyncSequence<[Int]>

    public init(_ input: Input) {
        banks = input.lines.map { $0.compactMap(\.wholeNumberValue) }.eraseToAnyAsyncSequence()
    }

    public func solvePart1() async throws -> Int {
        try await solve(numberOfDigits: 2)
    }

    public func solvePart2() async throws -> Int {
        try await solve(numberOfDigits: 12)
    }
    
    private func solve(numberOfDigits: Int) async throws -> Int {
        try await banks.sum { bank in
            let digits = maxDigits(from: bank[...], until: numberOfDigits)
            return digits.reduce(0) { $0 * 10 + $1 }
        }
    }
    
    private func maxDigits(from bank: ArraySlice<Int>, until limit: Int) -> [Int] {
        if limit == 0 { return [] }
        guard let value = bank.dropLast(limit - 1).max(),
              let index = bank.firstIndex(of: value) else { return [] }
        return [value] + maxDigits(from: bank[(index + 1)...], until: limit - 1)
    }
}
