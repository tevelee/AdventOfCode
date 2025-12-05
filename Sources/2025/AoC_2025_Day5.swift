import Utils

public final class AoC_2025_Day5 {
    private let ranges: [ClosedRange<Int>]
    private let ingredients: [Int]

    public init(_ input: Input) throws {
        let (ranges, ingredients) = try input.wholeInput.paragraphs.elements()
        self.ranges = try ranges.lazy
            .map {
                try $0.split(separator: "-").compactMap { Int($0) }.elements()
            }
            .map {
                ClosedRange(uncheckedBounds: $0)
            }
        self.ingredients = ingredients.compactMap(Int.init)
    }

    public func solvePart1() -> Int {
        ingredients.count { ingredient in
            ranges.contains { range in
                range.contains(ingredient)
            }
        }
    }

    public func solvePart2() -> Int {
        combineOverlappingRanges(in: ranges).sum(of: \.count)
    }

    private func combineOverlappingRanges(in ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var ranges = ranges.sorted(by: \.lowerBound)
        while let (first, second) = ranges.lazy.enumerated().adjacentPairs().first(where: { $0.element.overlaps($1.element) }) {
            let lower = min(first.element.lowerBound, second.element.lowerBound)
            let upper = max(first.element.upperBound, second.element.upperBound)
            ranges.replaceSubrange(first.offset ... second.offset, with: [lower ... upper])
        }
        return ranges
    }
}
