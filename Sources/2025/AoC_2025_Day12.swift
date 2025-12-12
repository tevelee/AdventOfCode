import Utils

public final class AoC_2025_Day12 {
    private let shapes: [ShapeID: [Bool]]
    private let regions: [Region]

    public init(_ input: Input) throws {
        var paragraphs = try Array(input.wholeInput.paragraphs)
        let regions = paragraphs.removeLast()
        self.shapes = try Dictionary(uniqueKeysWithValues: paragraphs.map { paragraph in
            guard let match = try /(?<id>\d+):\n(?<shape>[\.\#]{3}\n[\.\#]{3}\n[\.\#]{3})/.wholeMatch(in: paragraph.joined(separator: "\n"))?.output,
                let id = Int(match.id) else { throw ParseError() }
            return (id: id, shape: match.shape.filter { $0 == "." || $0 == "#" }.map { $0 == "#" })
        })
        self.regions = try regions.map { line in
            guard let match = try /(?<width>\d+)x(?<height>\d+): (?<counts>.*?)/.wholeMatch(in: line)?.output,
                let width = Int(match.width),
                let height = Int(match.height) else { throw ParseError() }
            return Region(
                width: width,
                height: height,
                counts: Dictionary(
                    uniqueKeysWithValues: match.counts
                        .split(separator: " ")
                        .compactMap { Int($0) }
                        .enumerated()
                        .map { (key: $0, value: $1) }
                )
            )
        }
    }

    public func solvePart1() -> Int {
        regions.count { region in
            let area = region.width * region.height
            let sum = region.counts.sum { id, count in
                shapes[id]!.count * count
            }
            return area >= sum
        }
    }
}

private typealias ShapeID = Int
private struct Region {
    let width: Int
    let height: Int
    let counts: [ShapeID: Int]
}
