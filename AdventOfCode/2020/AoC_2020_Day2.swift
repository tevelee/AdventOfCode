import Foundation
import Parsing

public final class AoC_2020_Day2 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        var result = 0
        for try await line in inputFileURL.lines {
            let (min, max, character, input) = parse(line: line)
            let count = input.filter { $0 == character }.count
            if (min...max).contains(count) {
                result += 1
            }
        }
        return result
    }

    public func solvePart2() async throws -> Int {
        var result = 0
        for try await line in inputFileURL.lines {
            let (minFrom1, maxFrom1, character, input) = parse(line: line)
            let min = minFrom1 - 1
            let max = maxFrom1 - 1
            if (input[min] == character && input[max] != character) || (input[min] != character && input[max] == character) {
                result += 1
            }
        }
        return result
    }

    private func parse(line: String) -> (min: Int, max: Int, character: Character, input: Substring) {
        let parser = Int.parser().skip("-").take(Int.parser()).skip(" ").take(PrefixUpTo(":")).skip(": ").take(Rest())
        let (min, max, character, input) = parser.parse(line[...]).output!
        return (min, max, character[0]!, input)
    }
}
