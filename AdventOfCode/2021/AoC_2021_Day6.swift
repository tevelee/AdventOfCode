import Foundation

public final class AoC_2021_Day6 {
    let numbers: [Int]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        numbers = input
            .trimmingCharacters(in: .newlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
    }

    public func solvePart1() -> Int {
        solve(until: 80)
    }

    public func solvePart2() -> Int {
        solve(until: 256)
    }

    private func solve(until days: Int) -> Int {
        var births: [Int: Int] = [:]
        for number in numbers {
            for day in stride(from: number, to: days, by: 7) {
                births[day, default: 0] += 1
            }
        }
        var count = numbers.count
        for day in 1 ..< days {
            count += births[day, default: 0]
            for followingDay in stride(from: day + 9, to: days, by: 7) {
                births[followingDay, default: 0] += births[day, default: 0]
            }
        }
        return count
    }
}
