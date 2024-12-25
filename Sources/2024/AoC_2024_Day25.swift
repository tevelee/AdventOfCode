import Utils

public final class AoC_2024_Day25 {
    let keys: [[Int]]
    let locks: [[Int]]

    public init(_ input: Input) throws {
        let blocks = try input.wholeInput.paragraphs
        var keys: [[Int]] = []
        var locks: [[Int]] = []
        for block in blocks {
            let isKey = block.first == "....."
            let values = (0 ..< 5).map { i in block.count { Array($0)[i] == "#" } - 1 }
            if isKey {
                keys.append(values)
            } else {
                locks.append(values)
            }
        }
        self.keys = keys
        self.locks = locks
    }

    public func solve() -> Int {
        locks.sum { lock in
            keys.count { key in
                (0 ..< 5).allSatisfy { lock[$0] + key[$0] <= 5 }
            }
        }
    }
}
