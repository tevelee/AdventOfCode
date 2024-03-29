
public final class AoC_2020_Day6 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        try String(contentsOf: inputFileURL)
            .paragraphs
            .sum { group in
                Set(group.flatMap(Array.init)).count
            }
    }

    public func solvePart2() async throws -> Int {
        try String(contentsOf: inputFileURL)
            .paragraphs
            .sum { group in
                let sets = group.map(Array.init).map(Set.init)
                return sets.reduce(into: sets[0]) { result, item in
                    result.formIntersection(item)
                }.count
            }
    }
}
