import Utils
import RegexBuilder

public final class AoC_2020_Day2 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        var result = 0
        for try await line in inputFileURL.lines {
            let (min, max, character, input) = try parse(line: line)
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
            let (minFrom1, maxFrom1, character, input) = try parse(line: line)
            let min = minFrom1 - 1
            let max = maxFrom1 - 1
            if (input[min] == character && input[max] != character) || (input[min] != character && input[max] == character) {
                result += 1
            }
        }
        return result
    }

    private struct ParsingError: Error {}

    private func parse(line: String) throws -> (min: Int, max: Int, character: Character, input: Substring) {
        let regex = Regex {
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            "-"
            TryCapture {
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            " "
            TryCapture {
                One(.word)
            } transform: {
                $0.first
            }
            ": "
            Capture {
                ZeroOrMore(.any)
            }
        }
        guard let values = try regex.firstMatch(in: line)?.output else {
            throw ParsingError()
        }
        return (values.1, values.2, values.3, values.4)
    }
}
