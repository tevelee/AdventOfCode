import Utils

public final class AoC_2024_Day19 {
    private let patterns: [[Color]]
    private let designs: [ArraySlice<Color>]

    public init(_ input: Input) throws {
        let (patterns, designs) = try input.wholeInput.paragraphs.elements()
        self.patterns = patterns[0].split(separator: ", ").map { $0.compactMap(Color.init) }
        self.designs = designs.map { $0.compactMap(Color.init)[...] }
    }

    public func solvePart1() -> Int {
        designs.count(where: canPrint)
    }

    public func solvePart2() -> Int {
        designs.sum(of: numberOfArrangements)
    }

    private lazy var canPrint = memoize(_canPrint)
    private func _canPrint(design: ArraySlice<Color>) -> Bool {
        if design.isEmpty {
            true
        } else {
            prefixingPatterns(from: design).contains(where: canPrint)
        }
    }

    private lazy var numberOfArrangements = memoize(_numberOfArrangements)
    private func _numberOfArrangements(of design: ArraySlice<Color>) -> Int {
        if design.isEmpty {
            1
        } else {
            prefixingPatterns(from: design).sum(of: numberOfArrangements)
        }
    }

    private func prefixingPatterns(from design: ArraySlice<Color>) -> some Sequence<ArraySlice<Color>> {
        patterns.lazy
            .filter(design.hasPrefix)
            .map { design.dropFirst($0.count) }
    }
}

private enum Color: Character, CustomStringConvertible {
    case white = "w"
    case blue = "u"
    case black = "b"
    case red = "r"
    case green = "g"

    var description: String {
        String(rawValue)
    }
}
