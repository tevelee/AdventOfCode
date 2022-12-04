import Foundation
import AsyncAlgorithms

public final class AoC_2022_Day3 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await input.lines
            .map(split)
            .compactMap(commonCharacter)
            .map(score)
            .sum()
    }

    public func solvePart2() async throws -> Int {
        try await input.lines
            .chunks(ofCount: 3)
            .compactMap(commonCharacter)
            .map(score)
            .sum()
    }

    private lazy var scores: [Character: Int] = {
        var result: [Character: Int] = [:]
        var score = 1
        let scalarValues = Array(UnicodeScalar("a").value...UnicodeScalar("z").value) + Array(UnicodeScalar("A").value...UnicodeScalar("Z").value)
        for value in scalarValues {
            let scalar = UnicodeScalar(value)!
            let character = Character(scalar)
            result[character] = score
            score += 1
        }
        return result
    }()

    @Sendable
    private func score(of character: Character) -> Int {
        scores[character, default: 0]
    }
}

@Sendable
private func split(line: String) -> [String] {
    let array = Array(line)
    let middle = Int(array.count / 2)
    return [array[..<middle], array[middle...]].map { String($0) }
}

@Sendable
private func commonCharacter(in strings: [String]) -> Character? {
    strings.map(Set.init).reduce { $0.intersection($1) }?.first
}
