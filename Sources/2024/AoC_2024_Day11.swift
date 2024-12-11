import Utils

public final class AoC_2024_Day11 {
    private let stones: [Stone]
    private var cache: [Stone: [Iteration: Int]] = [:]

    private typealias Stone = Int
    private typealias Iteration = Int

    public init(_ input: Input) throws {
        stones = try input.wholeInput.integers
    }

    public func solve(times interation: Int) -> Int {
        stones.sum {
            iterate(stone: $0, times: interation)
        }
    }
    
    private func iterate(stone: Int, times iteration: Int) -> Int {
        cached(stone: stone, iteration: iteration) {
            computeNumberOfStones(from: stone, at: iteration)
        }
    }

    private func computeNumberOfStones(from stone: Int, at iteration: Int) -> Int {
        if iteration == 0 {
            1
        } else {
            next(for: stone).sum {
                iterate(stone: $0, times: iteration - 1)
            }
        }
    }

    private func next(for stone: Int) -> [Int] {
        guard stone > 0 else { return [1] }
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

    private func cached(stone: Int, iteration: Int, computation: () -> Int) -> Int {
        if let cached = cache[stone]?[iteration] {
            return cached
        }
        let count = computation()
        cache[stone, default: [:]][iteration] = count
        return count
    }
}
