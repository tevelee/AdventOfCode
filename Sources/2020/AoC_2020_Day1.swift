
public final class AoC_2020_Day1 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        for try await line1 in inputFileURL.lines.compactMap({ Int($0) }) {
            for try await line2 in inputFileURL.lines.compactMap({ Int($0) }) {
                if line1 + line2 == 2020 {
                    return line1 * line2
                }
            }
        }
        return 0
    }

    public func solvePart2() async throws -> Int {
        for try await line1 in inputFileURL.lines.compactMap({ Int($0) }) {
            for try await line2 in inputFileURL.lines.compactMap({ Int($0) }) {
                for try await line3 in inputFileURL.lines.compactMap({ Int($0) }) {
                    if line1 + line2 + line3 == 2020 {
                        return line1 * line2 * line3
                    }
                }
            }
        }
        return 0
    }
}
