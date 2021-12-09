import Foundation

public final class AoC_2020_Day3 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        try await slope(stepX: 3)
    }

    public func solvePart2() async throws -> Int {
        try await slope(stepX: 1) * slope(stepX: 3) * slope(stepX: 5) * slope(stepX: 7) * slope(stepX: 1, stepY: 2)
    }

    private func slope(stepX: Int, stepY: Int = 1) async throws -> Int {
        var count = 0
        var x = 0
        var lineCount = 0
        for try await line in inputFileURL.lines {
            if x > 0, lineCount < stepY - 1 {
                lineCount += 1
                continue
            }
            let character = line[x % line.count]
            if character == "#" {
                count += 1
            }
            x += stepX
            lineCount = 0
        }
        return count
    }
}
