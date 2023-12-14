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

    private func numberOfPossibleArrangements(for entry: Entry) -> Int {
        var cache: [Entry: Int] = [:]
        let result = numberOfPossibleArrangements(for: entry, cache: &cache)
        return result
    }

    private func numberOfPossibleArrangements(for entry: Entry, cache: inout [Entry: Int]) -> Int {
        if let value = cache[entry] {
            return value
        }
        let value = recurse(for: entry, cache: &cache)
        cache[entry] = value
        return value

        func recurse(for entry: Entry, cache: inout [Entry: Int]) -> Int {
            switch entry.pattern.first {
            case ".":
                processDot(entry, &cache)
            case "?":
                processQuestionMark(entry, &cache)
            case "#":
                processHash(for: entry, cache: &cache)
            case nil:
                processEndOfPattern(for: entry)
            default:
                fatalError("invalid character")
            }
        }

        func processDot(_ entry: Entry, _ cache: inout [Entry : Int]) -> Int {
            numberOfPossibleArrangements(
                for: Entry(pattern: entry.pattern.dropFirst(), groups: entry.groups),
                cache: &cache
            )
        }

        func processQuestionMark(_ entry: Entry, _ cache: inout [Entry : Int]) -> Int {
            let withDot = numberOfPossibleArrangements(
                for: Entry(pattern: ["."] + entry.pattern.dropFirst(), groups: entry.groups),
                cache: &cache
            )
            let withHash = numberOfPossibleArrangements(
                for: Entry(pattern: ["#"] + entry.pattern.dropFirst(), groups: entry.groups),
                cache: &cache
            )
            return withDot + withHash
        }

        func processHash(for entry: Entry, cache: inout [Entry: Int]) -> Int {
            guard let sizeOfFirstGroup = entry.groups.first else {
                return 0
            }
            let prefix = entry.pattern.prefix { $0 == "#" || $0 == "?" }
            let sizeOfPrefix = prefix.count
            if entry.pattern == prefix, sizeOfFirstGroup == sizeOfPrefix {
                return numberOfPossibleArrangements(
                    for: Entry(pattern: [], groups: entry.groups.dropFirst()),
                    cache: &cache
                )
            }
            guard sizeOfFirstGroup <= sizeOfPrefix, entry.pattern[safe: sizeOfFirstGroup] != "#" else {
                return 0
            }
            return numberOfPossibleArrangements(
                for: Entry(
                    pattern: entry.pattern.dropFirst(sizeOfFirstGroup + 1),
                    groups: entry.groups.dropFirst()
                ),
                cache: &cache
            )
        }

        func processEndOfPattern(for entry: Entry) -> Int {
            entry.groups.isEmpty ? 1 : 0
        }
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
