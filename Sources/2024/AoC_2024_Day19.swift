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
        if design.isEmpty { return true }
        for pattern in patterns where design.hasPrefix(pattern) && canPrint(design.dropFirst(pattern.count)) {
            return true
        }
        return false
    }

    private lazy var numberOfArrangements = memoize(_numberOfArrangements)
    private func _numberOfArrangements(of design: ArraySlice<Color>) -> Int {
        if design.isEmpty { return 1 }
        var result = 0
        for pattern in patterns {
            if design.hasPrefix(pattern) {
                result += numberOfArrangements(design.dropFirst(pattern.count))
            }
        }
        return result
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
