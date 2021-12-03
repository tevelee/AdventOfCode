import Foundation
import Parsing

public final class AoC_2021_Day3 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        var bits: [Int] = []
        var count = 0
        for try await line in inputFileURL.lines {
            if bits.isEmpty {
                bits = Array(repeating: 0, count: line.count)
            }
            for (index, bit) in Array(line).enumerated() where bit == "0" {
                bits[index] += 1
            }
            count += 1
        }
        let gamma = bits.map { $0 > count/2 ? 1 : 0 }
        let episilon = bits.map { $0 > count/2 ? 0 : 1 }
        return binary(from: gamma) * binary(from: episilon)
    }

    public func solvePart2() async throws -> Int {
        let allNumbers = try await inputFileURL.lines.collect()
        let mostCommon = partition(allNumbers, by: >)
        let leastCommon = partition(allNumbers, by: <=)
        return binary(from: mostCommon) * binary(from: leastCommon)
    }

    private func partition(_ allNumbers: [String], by condition: (Int, Int) -> Bool) -> String {
        var candidates = allNumbers
        for i in 0 ..< allNumbers[0].count {
            let partition = Dictionary(grouping: candidates) { $0[i] }
            let c0 = partition["0"] ?? []
            let c1 = partition["1"] ?? []
            if c0.isEmpty {
                candidates = c1
            } else if c1.isEmpty {
                candidates = c0
            } else {
                candidates = condition(c0.count, c1.count) ? c0 : c1
            }
            if candidates.count == 1 {
                break
            }
        }
        return candidates[0]
    }

    private func binary(from string: String) -> Int {
        let integers = Array(string).map { $0 == "1" ? 1 : 0 }
        return binary(from: integers)
    }

    private func binary(from integers: [Int]) -> Int {
        integers.reduce(0) { result, item in
            result * 2 + item
        }
    }
}

private extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

private extension String {
    subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}
