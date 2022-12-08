import Algorithms
import RegexBuilder

public final class AoC_2021_Day17 {
    struct Point: Equatable {
        var x: Int
        var y: Int
    }

    struct TargetArea {
        let x: ClosedRange<Int>
        let y: ClosedRange<Int>

        func contains(point: Point) -> Bool {
            x.contains(point.x) && y.contains(point.y)
        }
    }

    let targetArea: TargetArea
    let startingPoint = Point(x: 0, y: 0)

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        let number = TryCapture {
            Optionally {
                "-"
            }
            OneOrMore(.digit)
        } transform: {
            Int($0)
        }
        let regex = Regex {
            "target area: x="
            number
            ".."
            number
            ", y="
            number
            ".."
            number
        }
        let dimensions = try! regex.firstMatch(in: input)!.output
        targetArea = TargetArea(x: dimensions.1 ... dimensions.2, y: dimensions.3 ... dimensions.4)
    }

    public func solvePart1() -> Int {
        velocities()
            .compactMap(heightByThrowing)
            .max()!
    }

    public func solvePart2() -> Int {
        velocities()
            .compactMap(heightByThrowing)
            .count
    }

    private func velocities() -> [Point] {
        product(0...targetArea.x.max()!, targetArea.y.min()!...abs(targetArea.y.min()!)).map(Point.init)
    }

    private func heightByThrowing(initialVelocity: Point) -> Int? {
        var point = startingPoint
        var velocity = initialVelocity
        var maxHeight = 0
        //var points: [Point] = []
        while point.x < targetArea.x.max()! && point.y > targetArea.y.min()! {
            if point.y > maxHeight {
                maxHeight = point.y
            }
            point = Point(x: point.x + velocity.x, y: point.y + velocity.y)
            //points.append(point)
            velocity.x = change(value: velocity.x, by: 1, toward: 0)
            velocity.y -= 1
            if targetArea.contains(point: point) {
                //visualize(points)
                return maxHeight
            }
        }
        return nil
    }

    private func change(value: Int, by difference: Int, toward goal: Int) -> Int {
        guard value != goal else { return value }
        if value > goal {
            return value - difference
        } else {
            return value + difference
        }
    }

    private func visualize(_ points: [Point]) {
        print(points)
        for y in stride(from: points.map(\.y).max()!, through: targetArea.y.min()!, by: -1) {
            for x in 0 ... targetArea.x.upperBound {
                let point = Point(x: x, y: y)
                let character: Character
                if x == 0 && y == 0 {
                    character = "S"
                } else if points.contains(point) {
                    character = "#"
                } else if targetArea.contains(point: point) {
                    character = "T"
                } else {
                    character = "."
                }
                print(character, terminator: "")
            }
            print()
        }
    }
}
