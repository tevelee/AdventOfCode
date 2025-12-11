import Utils

public final class AoC_2025_Day11 {
    private let connections: [String: [String]]

    public init(_ input: Input) throws {
        let connections = try input.wholeInput.lines.map { line in
            let (left, right) = try line.split(separator: ": ").elements()
            return (input: String(left), outputs: right.split(separator: " ").map(String.init))
        }
        self.connections = Dictionary(uniqueKeysWithValues: connections)
    }

    public func solvePart1() -> Int {
        numberOfPaths("you", "out")
    }

    public func solvePart2() -> Int {
        numberOfPaths("svr", "fft", "dac", "out") + numberOfPaths("svr", "dac", "fft", "out")
    }


    private func numberOfPaths(_ nodes: String...) -> Int {
        nodes.adjacentPairs().product(of: numberOfPaths)
    }

    private lazy var numberOfPaths = memoize(_numberOfPaths)

    private func _numberOfPaths(from source: String, to destination: String) -> Int {
        if source == destination {
            1
        } else {
            connections[source, default: []].sum {
                numberOfPaths($0, destination)
            }
        }
    }
}
