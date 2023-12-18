import Algorithms

final class AoC_2023_Day12 {
    private let entries: AnyAsyncSequence<Entry>

    init(_ input: Input) {
        entries = input.lines
            .map { line in
                guard let (pattern, rest) = line.words.headAndTail else { throw ParseError() }
                return Entry(pattern: Array(pattern), groups: rest.joined().integers)
            }
            .eraseToAnyAsyncSequence()
    }

    func solvePart1() async throws -> Int {
        try await entries.sum(of: numberOfPossibleArrangements)
    }

    func solvePart2() async throws -> Int {
        try await entries.map(\.unfolded).sum(of: numberOfPossibleArrangements)
    }

    private lazy var numberOfPossibleArrangements = memoize(_numberOfPossibleArrangements)

    private func _numberOfPossibleArrangements(for entry: Entry) -> Int {
        switch entry.pattern.first {
        case ".":
            processDot(entry)
        case "?":
            processQuestionMark(entry)
        case "#":
            processHash(for: entry)
        case nil:
            processEndOfPattern(for: entry)
        default:
            fatalError("invalid character")
        }
    }

    private func processDot(_ entry: Entry) -> Int {
        numberOfPossibleArrangements(Entry(pattern: entry.pattern.dropFirst(), groups: entry.groups))
    }

    private func processQuestionMark(_ entry: Entry) -> Int {
        let withDot = numberOfPossibleArrangements(Entry(pattern: ["."] + entry.pattern.dropFirst(), groups: entry.groups))
        let withHash = numberOfPossibleArrangements(Entry(pattern: ["#"] + entry.pattern.dropFirst(), groups: entry.groups))
        return withDot + withHash
    }

    private func processHash(for entry: Entry) -> Int {
        guard let sizeOfFirstGroup = entry.groups.first else {
            return 0
        }
        let prefix = entry.pattern.prefix { $0 == "#" || $0 == "?" }
        let sizeOfPrefix = prefix.count
        if entry.pattern == prefix, sizeOfFirstGroup == sizeOfPrefix {
            return numberOfPossibleArrangements(Entry(pattern: [], groups: entry.groups.dropFirst()))
        }
        guard sizeOfFirstGroup <= sizeOfPrefix, entry.pattern[safe: sizeOfFirstGroup] != "#" else {
            return 0
        }
        return numberOfPossibleArrangements(
            Entry(
                pattern: entry.pattern.dropFirst(sizeOfFirstGroup + 1),
                groups: entry.groups.dropFirst()
            )
        )
    }

    private func processEndOfPattern(for entry: Entry) -> Int {
        entry.groups.isEmpty ? 1 : 0
    }
}

private struct Entry: Hashable {
    let pattern: ArraySlice<Character>
    let groups: ArraySlice<Int>

    var unfolded: Entry {
        Entry(
            pattern: pattern.repeated(5, separator: ["?"]),
            groups: groups.repeated(5)
        )
    }
}

extension Entry {
    init(pattern: [Character], groups: [Int]) {
        self.pattern = pattern[...]
        self.groups = groups[...]
    }
}

private extension ArraySlice {
    func repeated(_ times: Int, separator: Self = []) -> [Element] {
        Array<Self>(repeating: self, count: times).interspersed(with: separator).flatMap { $0 }
    }
}
