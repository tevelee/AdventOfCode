import Algorithms
import Utils

public final class AoC_2021_Day13 {
    struct Point: Hashable {
        let x: Int
        let y: Int
    }

    let dots: Set<Point>
    let folds: [(axis: String, value: Int)]
    let width: Int
    let height: Int

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        let sections = contents.paragraphs
        let points = sections[0]
            .map { $0.split(separator: ",").map(String.init).compactMap(Int.init) }
            .map { Point(x: $0[0], y: $0[1]) }
        dots = Set(points)
        folds = sections[1]
            .compactMap { line -> (axis: String, value: Int)? in
                guard let input = line.split(separator: " ").last else { return nil }
                let segments = input.split(separator: "=").map(String.init)
                guard let int = Int(segments[1]) else { return nil }
                return (segments[0], int)
            }
        width = folds.first { $0.axis == "x" }!.value * 2 + 1
        height = folds.first { $0.axis == "y" }!.value * 2 + 1
    }

    public func solvePart1() -> Int {
        fold(dots: dots,
             width: width,
             height: height,
             instruction: folds[0]).dots.count
    }

    public func solvePart2() -> String {
        var dots = dots
        var width = self.width
        var height = self.height
        for instruction in folds {
            //debugPrint(dots, width: width, height: height, fold: instruction)
            (width, height, dots) = fold(dots: dots, width: width, height: height, instruction: instruction)
        }
        debugPrint(dots, width: width, height: height)
        return String(pointsByCharacters(in: dots).map(draw).map { characters4x6[$0] ?? "?" })
    }

    private func fold(dots: Set<Point>,
                      width: Int,
                      height: Int,
                      instruction fold: (axis: String, value: Int)) -> (width: Int, height: Int, dots: Set<Point>) {
        if fold.axis == "x" {
            return (fold.value, height, Set(dots.map { $0.x < fold.value ? $0 : Point(x: width - 1 - $0.x, y: $0.y) }))
        } else {
            return (width, fold.value, Set(dots.map { $0.y < fold.value ? $0 : Point(x: $0.x, y: height - 1 - $0.y) }))
        }
    }

    private func pointsByCharacters(in dots: Set<Point>) -> [Set<Point>] {
        (0 ..< 8).map { index -> Set<Point> in
            let range = (index * 5) ..< (index + 1) * 5
            return Set(dots.filter { range.contains($0.x) }.map { Point(x: $0.x - index * 5, y: $0.y) })
        }
    }

    private func draw(pixels: Set<Point>) -> String {
        (0 ..< 6).map { y in
            (0 ..< 4)
                .map { Point(x: $0, y: y) }
                .map { pixels.contains($0) ? "#" : "." }
                .joined(separator: "")
                .trimTrailingWhitespaces()
        }.joined(separator: "\n")
    }

    private func debugPrint(_ dots: Set<Point>, width: Int, height: Int, fold: (axis: String, value: Int)? = nil) {
        for y in 0 ..< height {
            for x in 0 ..< width {
                if let fold = fold, fold.axis == "x", x == fold.value {
                    print(" | ", terminator: "")
                } else if let fold = fold, fold.axis == "y", y == fold.value {
                    print("--", terminator: "")
                } else {
                    print(dots.contains(Point(x: x, y: y)) ? "##" : "  ", terminator: "")
                }
            }
            print()
        }
        print()
    }
}

private extension String {
    func trimTrailingWhitespaces() -> String {
        var substring = self[...]
        while substring.last?.isWhitespace == true {
            substring = substring.dropLast()
        }
        return String(substring)
    }

}
