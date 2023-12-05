import Algorithms

final class AoC_2023_Day5 {
    private let seeds: [Int]
    private let maps: [Map]

    struct ParseError: Error {}

    init(_ input: Input) throws {
        guard let (seeds, maps) = try input.wholeInput.paragraphs.headAndTail else {
            throw ParseError()
        }
        self.seeds = seeds.joined().integers
        self.maps = maps.map { lines in
            Map(ranges: lines.dropFirst().map(\.integers).map { integers in
                Map.Range(source: integers[1], destination: integers[0], length: integers[2])
            }.sorted(by: \.source))
        }
    }

    func solvePart1() -> Int {
        seeds.min { seed in
            maps.reduce(seed, resolve)
        } ?? 0
    }

    func solvePart2() -> Int {
        var ranges = seeds.chunks(ofCount: 2).map {
            ClosedRange(lowerBound: $0.first!, length: $0.last!)
        }
        for map in maps {
            var newRanges: [ClosedRange<Int>] = []
            for range in ranges {
                var lowerBound = range.lowerBound
                let upperBound = range.upperBound
                for mapping in map.ranges {
                    if lowerBound < mapping.source {
                        newRanges.append(ClosedRange(lowerBound: lowerBound, upperBound: min(upperBound, mapping.source - 1))!)
                        lowerBound = mapping.source
                        if lowerBound > upperBound { break }
                    }
                    let end = mapping.sourceRange.upperBound
                    if lowerBound <= end {
                        newRanges.append(ClosedRange(lowerBound: lowerBound + mapping.adjustment, upperBound: min(upperBound, end) + mapping.adjustment)!)
                        lowerBound = end + 1
                        if lowerBound > upperBound { break }
                    }
                }
                if let range = ClosedRange(lowerBound: lowerBound, upperBound: upperBound) {
                    newRanges.append(range)
                }
            }
            ranges = newRanges
        }

        return ranges.min(of: \.lowerBound) ?? 0
    }

    private func resolve(number: Int, in map: Map) -> Int {
        if let range = map.ranges.first(where: { $0.sourceRange.contains(number) }) {
            let offset = number - range.source
            return range.destination + offset
        }
        return number
    }
}

private struct Map {
    let ranges: [Range]

    struct Range {
        let source: Int
        let destination: Int
        let length: Int

        var sourceRange: ClosedRange<Int> {
            ClosedRange(lowerBound: source, length: length)
        }

        var adjustment: Int {
            destination - source
        }
    }
}

private extension ClosedRange where Bound == Int {
    init(lowerBound: Bound, length: Int) {
        self = lowerBound ... lowerBound + length - 1
    }

    init?(lowerBound: Bound, upperBound: Bound) {
        guard lowerBound <= upperBound else { return nil }
        self.init(uncheckedBounds: (lowerBound, upperBound))
    }
}
