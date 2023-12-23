import Algorithms
import Utils

final class AoC_2023_Day22 {
    private var bricks: Bricks

    init(_ input: Input) throws {
        bricks = try Bricks(bricks: input.wholeInput.lines.map(Brick.init))
    }

    func solvePart1() -> Int {
        bricks.numberOfBricksThatAreSafeToDisintegrate()
    }

    func solvePart2() -> Int {
        bricks.sumWhereOthersWouldFall()
    }
}

private struct Bricks {
    private var bricks: [Brick]
    private var numberOfFallenBricks = 0
    private lazy var safeToDisintegrate = Set(bricks.filter(safeToDisintegrate))

    init(bricks: [Brick]) {
        self.bricks = bricks.sorted(by: \.minZ)
        numberOfFallenBricks = freeFall()
    }

    mutating func numberOfBricksThatAreSafeToDisintegrate() -> Int {
        safeToDisintegrate.count
    }

    mutating func sumWhereOthersWouldFall() -> Int {
        bricks.filter { !safeToDisintegrate.contains($0) }.sum { brick in
            Bricks(bricks: bricks.filter { $0 != brick }).numberOfFallenBricks
        }
    }

    private func safeToDisintegrate(brick: Brick) -> Bool {
        bricks(from: brick) { $0.z += 1 }.allSatisfy {
            numberOfSupporters(of: $0) > 1
        }
    }

    private func numberOfSupporters(of brick: Brick) -> Int {
        bricks(from: brick) { $0.z -= 1 }.count
    }

    @discardableResult
    mutating func freeFall() -> Int {
        var indices: Set<Int> = []
        for index in bricks.indices {
            while true {
                let brick = bricks[index]
                guard brick.minZ > 1 else { break }
                let oneBelow = brick.apply { $0.z -= 1 }
                if bricks.filter({ $0 != brick }).contains(where: oneBelow.intersects) {
                    break
                } else {
                    //print("fall of \(brick)")
                    bricks[index] = oneBelow
                    indices.insert(index)
                }
            }
        }
        return indices.count
    }

    private func bricks(from brick: Brick, where condition: (inout Position) -> Void) -> [Brick] {
        let modified = brick.apply(condition)
        return bricks.filter { $0 != brick }.filter(modified.intersects)
    }
}

private struct Position: Hashable, CustomStringConvertible {
    var x, y, z: Int

    func apply(_ block: (inout Position) -> Void) -> Position {
        var copy = self
        block(&copy)
        return copy
    }

    var description: String {
        "{\(x),\(y),\(z)}"
    }
}

private struct Brick: Hashable, CustomStringConvertible {
    var start, end: Position

    var minZ: Int { start.z }

    func apply(_ block: (inout Position) -> Void) -> Brick {
        var copy = self
        block(&copy.start)
        block(&copy.end)
        return copy
    }

    func intersects(with other: Brick) -> Bool {
        start.x <= other.end.x && end.x >= other.start.x &&
        start.y <= other.end.y && end.y >= other.start.y &&
        start.z <= other.end.z && end.z >= other.start.z
    }

    var description: String {
        "\(start)-\(end)"
    }
}

extension Brick {
    init(rawString: String) throws {
        let positions = try rawString.split(separator: "~").lazy.map(String.init).map(Position.init)
        guard let first = positions.first, let last = positions.last else { throw ParseError() }
        start = first
        end = last
    }
}

extension Position {
    init(rawString: String) throws {
        let coordinates = rawString.integers
        guard coordinates.count == 3 else { throw ParseError() }
        x = coordinates[0]
        y = coordinates[1]
        z = coordinates[2]
    }
}
