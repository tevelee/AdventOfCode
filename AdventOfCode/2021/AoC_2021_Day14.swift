import Algorithms
import Foundation

public final class AoC_2021_Day14 {
    let start: String

    struct Pair<Value: Hashable>: Hashable {
        let left: Value
        let right: Value

        init(_ tuple: (Value, Value)) {
            left = tuple.0
            right = tuple.1
        }

        init(_ left: Value, _ right: Value) {
            self.left = left
            self.right = right
        }
    }

    let transformations: [Pair<Character>: Character]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        let sections = contents.paragraphs
        start = sections[0][0]
        let pairs: [(Pair<Character>, Character)] = sections[1]
            .map { $0.components(separatedBy: " -> ") }
            .map { (Pair($0[0].first!, $0[0].last!), $0[1].first!) }
        transformations = Dictionary(uniqueKeysWithValues: pairs)
    }

    public func solvePart1() -> Int {
        iterate(until: 10)
    }

    public func solvePart2() -> Int {
        iterate(until: 40)
    }

    private func iterate(until n: Int) -> Int {
        var characterCounts = Dictionary(grouping: start) { $0 }.mapValues(\.count)
        var pairs: [Pair<Character>: Int] = start.adjacentPairs().map(Pair.init).reduce(into: [:]) { $0[$1, default: 0] += 1 }

        for _ in 0 ..< n {
            var newPairs: [Pair<Character>: Int] = [:]
            for (pair, count) in pairs where count > 0 {
                guard let newCharacter = transformations[pair] else { continue }
                characterCounts[newCharacter, default: 0] += count
                newPairs[Pair(pair.left, newCharacter), default: 0] += count
                newPairs[Pair(newCharacter, pair.right), default: 0] += count
            }
            pairs = newPairs
        }

        let minAndMax = characterCounts.values.minAndMax()!
        return minAndMax.max - minAndMax.min
    }
}
