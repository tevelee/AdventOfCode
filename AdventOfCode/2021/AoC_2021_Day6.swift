import Foundation

public final class AoC_2021_Day6 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        try solve(until: 80)
    }

    public func solvePart2() async throws -> Int {
        try solve(until: 256)
    }

    private func solve(until days: Int) throws -> Int {
        let numbers = try String(contentsOf: inputFileURL)
            .trimmingCharacters(in: .newlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
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
