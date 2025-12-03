import Utils

@MainActor
public final class AoC_2025_Day2 {
    private let ranges: [ClosedRange<Int>]

    public init(_ input: Input) throws {
        ranges = try input.wholeInput
            .split(separator: /\,|\n/)
            .map { try $0.split("-").compactMap(Int.init).elements() }
            .map { ClosedRange(uncheckedBounds: $0) }
    }

    public func solvePart1() -> Int {
        solve { number, _ in
            Self.nextInvalid(after: number, repetitions: 2)
        }
    }

    public func solvePart2() -> Int {
        solve { number, bound in
            (2 ... bound.digits.count)
                .map { repetitions in
                    Self.nextInvalid(after: number, repetitions: repetitions)
                }
                .sorted()
                .first!
        }
    }
    
    public func solve(next: @escaping (Int, Int) -> Int) -> Int {
        ranges.sum { range in
            return AnySequence {
                var currentValue = range.lowerBound - 1
                return AnyIterator {
                    let newValue = next(currentValue, range.upperBound)
                    defer { currentValue = newValue }
                    return newValue
                }
            }
            .prefix { $0 <= range.upperBound }
            .sum()
        }
    }
    
    private static func nextInvalid(after number: Int, repetitions: Int) -> Int {
        let digits = number.digits
        
        guard digits.count.isMultiple(of: repetitions) && !digits.allSatisfy({ $0 == 9 }) else {
            return nextInvalid(after: pow10(digits.count), repetitions: repetitions)
        }
        let tens = pow10(digits.count / repetitions)
        let segment = number / pow10(digits.count - digits.count / repetitions)

        func repeating(segment: Int) -> Int {
            var candidate = 0
            for _ in 1 ... repetitions {
                candidate = candidate * tens + segment
            }
            return candidate
        }
        
        let candidate = repeating(segment: segment)
        if candidate > number {
            return candidate
        } else {
            return repeating(segment: segment + 1)
        }
    }
    
    private static let pow10 = memoize { pow($0, base: 10) }
}

private extension Int {
    var digits: [Int] {
        var digits: [Int] = []
        var n = abs(self)
        if n == 0 {
            return [0]
        }
        while n > 0 {
            digits.append(n % 10)
            n /= 10
        }
        return digits.reversed()
    }
}
