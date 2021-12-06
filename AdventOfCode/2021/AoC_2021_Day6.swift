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

    private func solve(until upperBound: Int) throws -> Int {
        var numbers = try String(contentsOf: inputFileURL)
            .trimmingCharacters(in: .newlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
        //let count = numbers.count
        var index = 0
        while index < numbers.count {
            defer { index += 1 }
            let number = numbers[index]
            if number <= upperBound {
                let initial = number + 1
                let numberOfIterations = Int((upperBound - initial) / 7)
                let newColumns = (0 ... numberOfIterations).map { initial + $0 * 7 + 8 }.filter { $0 - upperBound <= 8 }
                numbers.append(contentsOf: newColumns)
            }
        }
        //debugPrint(numbers: numbers, originalCount: count, upperBound: upperBound)
        return numbers.count
    }

    private func debugPrint(numbers: [Int], originalCount count: Int, upperBound: Int) {
        let numbersToPrint = numbers[..<count] + numbers[count...].sorted()
        for day in 0 ... upperBound {
            print(String(day).padding(toLength: 2, withPad: " ", startingAt: 0), " | ", numbersToPrint
                .map { number -> Int in
                    if number > day { return number - day }
                    let mod = (number - day) % 7
                    return mod < 0 ? mod + 7 : mod
                }
                .map { String($0).padding(toLength: 2, withPad: " ", startingAt: 0) }
                .joined(separator: " "))
        }
    }
}
