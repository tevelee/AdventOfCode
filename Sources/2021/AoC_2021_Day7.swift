
public final class AoC_2021_Day7 {
    let positions: [Int]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        positions = contents
            .trimmingCharacters(in: .newlines)
            .split(separator: ",")
            .map(String.init)
            .compactMap(Int.init)
    }

    public func solvePart1() -> Int {
        solve { $0 }
    }

    public func solvePart2() -> Int {
        solve { n in
            n * (n + 1) / 2
        }
    }

    private func solve(transform: (Int) -> Int) -> Int {
        (1 ..< positions.count)
            .map { destination in
                positions
                    .map { abs(destination - $0) }
                    .sum(of: transform)
            }
            .min()!
    }
}
