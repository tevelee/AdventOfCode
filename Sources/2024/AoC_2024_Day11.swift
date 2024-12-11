import Utils

public final class AoC_2024_Day11 {
    private let stones: [Int]

    public init(_ input: Input) throws {
        stones = try input.wholeInput.integers
    }

    private struct Blink: Hashable {
        let stone: Int
        let iteration: Int
    }

    public func solve(times iteration: Int) -> Int {
        computeNumberOfStones(for: stones, after: iteration)
    }

    private func computeNumberOfStones(for stones: [Int], after iteration: Int) -> Int {
        stones.sum { stone in
            computeNumberOfStones(Blink(stone: stone, iteration: iteration))
        }
    }

    private lazy var computeNumberOfStones = memoize(_computeNumberOfStones)
    private func _computeNumberOfStones(at blink: Blink) -> Int {
        if blink.iteration == 0 {
            1
        } else {
            computeNumberOfStones(
                for: newStones(from: blink.stone),
                after: blink.iteration - 1
            )
        }
    }

    private func newStones(from stone: Int) -> [Int] {
        if stone == 0 {
            return [1]
        }
        let string = String(stone)
        let numberOfDigits = string.utf8.count
        let (quotient, remainder) = numberOfDigits.quotientAndRemainder(dividingBy: 2)
        return if remainder == 0,
          let firstHalf = Int(string.prefix(quotient)),
          let secondHalf = Int(string.suffix(quotient)) {
            [firstHalf, secondHalf]
        } else {
            [stone * 2024]
        }
    }
}
