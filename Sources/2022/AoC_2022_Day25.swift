import Utils

public final class AoC_2022_Day25 {
    private let input: Input
    private let snafuToDecimal: [Character: Int] = ["2": 2, "1": 1, "0": 0, "-": -1, "=": -2]
    private let decimalToSnafu: [Int: Character] = [2: "2", 1: "1", 0: "0", -1: "-", -2: "="]

    public init(_ input: Input) throws {
        self.input = input
    }

    public func solve() async throws -> String {
        let decimal = try await input.lines.sum(of: decimal)
        return snafu(from: decimal)
    }

    private func snafu(from decimal: Int) -> String {
        var result: [Character] = []
        var value = decimal
        while value > 0 {
            let (quotient, remainder) = value.quotientAndRemainder(dividingBy: 5)
            if remainder <= 2 {
                result.append(decimalToSnafu[remainder]!)
                value = quotient
            } else {
                result.append(decimalToSnafu[remainder - 5]!)
                value = quotient + 1
            }
        }
        return String(result.reversed())
    }

    private func decimal(from snafu: String) -> Int {
        var result = 0
        var number = snafu
        var multiplier = 1
        while let digit = number.popLast() {
            result += snafuToDecimal[digit]! * multiplier
            multiplier *= 5
        }
        return result
    }
}
