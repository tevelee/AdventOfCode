import Collections
import Utils

public final class AoC_2024_Day15 {
    private let startPosition: Position
    private let walls: Set<Position>
    private let boxes: Set<Position>
    private let instructions: [Direction]

    public init(_ input: Input) throws {
        let (map, intructions) = try input.wholeInput.paragraphs.elements()
        var walls: Set<Position> = []
        var boxes: Set<Position> = []
        var startPosition = Position(x: 0, y: 0)
        for (y, row) in map.enumerated() {
            for (x, character) in row.enumerated() {
                let position = Position(x: x, y: y)
                switch character {
                    case "#": walls.insert(position)
                    case "O": boxes.insert(position)
                    case "@": startPosition = position
                    default: break
                }
            }
        }
        self.startPosition = startPosition
        self.walls = walls
        self.boxes = boxes
        self.instructions = intructions.flatMap {
            $0.compactMap(Direction.init)
        }
    }

    public func solvePart1() -> Int {
        var boxes = boxes
        var position = startPosition
        for direction in instructions {
            let next = position.position(in: direction)
            if let movable = boxesToMove(in: direction, from: next, allBoxes: boxes) {
                for position in movable.reversed() {
                    boxes.remove(position)
                    boxes.insert(position.position(in: direction))
                }
                position = next
            }
        }
        return boxes.sum { 100 * $0.y + $0.x }
    }

    private func boxesToMove(in direction: Direction, from position: Position, allBoxes: Set<Position>) -> [Position]? {
        var next = position
        var result: [Position] = []
        while true {
            if allBoxes.contains(next) {
                result.append(next)
                next = next.position(in: direction)
            } else if walls.contains(next) {
                return nil
            } else {
                return result
            }
        }
    }

    private func visualize(position: Position, boxes: Set<Position>) {
        guard let (minY, maxY) = walls.minAndMaxValues(of: \.y),
              let (minX, maxX) = walls.minAndMaxValues(of: \.x) else { return }
        for y in minY...maxY {
            for x in minX...maxX {
                let p = Position(x: x, y: y)
                let character: Character = if walls.contains(p) {
                    "#"
                } else if boxes.contains(p) {
                    "O"
                } else if position == p {
                    "@"
                } else {
                    "."
                }
                print(character, terminator: "")
            }
            print()
        }
    }

    public func solvePart2() -> Int {
        var boxes = Set(boxes.map { WideBox($0.twiceX) })
        var position = startPosition.twiceX
        let walls = Set(walls.flatMap { WideBox($0.twiceX).positions })
        for direction in instructions {
            if let next = boxesToMove(in: direction, from: position, walls: walls, allBoxes: boxes) {
                for position in next.boxes.reversed() {
                    boxes.remove(position)
                    boxes.insert(position.moved(in: direction))
                }
                position = next.position
            }
        }
        return boxes.sum { 100 * $0.y + $0.x1 }
    }

    private func boxesToMove(in direction: Direction, from position: Position, walls: Set<Position>, allBoxes: Set<WideBox>) -> (position: Position, boxes: [WideBox])? {
        let nextPosition = position.position(in: direction)
        if walls.contains(nextPosition) {
            return nil
        }
        let possibleBoxes = position.possibleBoxes(in: direction)
        var result = possibleBoxes.filter(allBoxes.contains)
        if result.isEmpty {
            return (nextPosition, [])
        }
        while true {
            let nextPositions = result.flatMap(\.positions).map { $0.position(in: direction) }
            if nextPositions.contains(where: walls.contains) {
                return nil
            }
            let nextBoxes = Set(result.flatMap { $0.possibleBoxes(in: direction) })
            let boxesToMove = nextBoxes.intersection(allBoxes).subtracting(result)
            if boxesToMove.isEmpty {
                return (nextPosition, result)
            }
            result.append(contentsOf: boxesToMove)
        }
    }

    private func visualize(position: Position, boxes: Set<WideBox>, walls: Set<Position>) {
        guard let (minY, maxY) = walls.minAndMaxValues(of: \.y),
              let (minX, maxX) = walls.minAndMaxValues(of: \.x) else { return }
        for y in minY...maxY {
            for x in minX...maxX {
                let p = Position(x: x, y: y)
                let character: Character = if walls.contains(p) {
                    "#"
                } else if boxes.map({ Position(x: $0.x1, y: $0.y) }).contains(p) {
                    "["
                } else if boxes.map({ Position(x: $0.x2, y: $0.y) }).contains(p) {
                    "]"
                } else if position == p {
                    "@"
                } else {
                    "."
                }
                print(character, terminator: "")
            }
            print()
        }
    }
}

private enum Direction: Character {
    case up = "^"
    case left = "<"
    case down = "v"
    case right = ">"
}

private struct Position: Hashable {
    let x, y: Int

    func position(in direction: Direction) -> Position {
        switch direction {
            case .up: Position(x: x, y: y - 1)
            case .left: Position(x: x - 1, y: y)
            case .down: Position(x: x, y: y + 1)
            case .right: Position(x: x + 1, y: y)
        }
    }

    var twiceX: Position {
        Position(x: x * 2, y: y)
    }

    func possibleBoxes(in direction: Direction) -> [WideBox] {
        switch direction {
        case .right: [WideBox(Position(x: x + 1, y: y))]
        case .left: [WideBox(Position(x: x - 2, y: y))]
        case .up: [WideBox(Position(x: x, y: y - 1)), WideBox(Position(x: x - 1, y: y - 1))]
        case .down: [WideBox(Position(x: x, y: y + 1)), WideBox(Position(x: x - 1, y: y + 1))]
        }
    }
}

private struct WideBox: Hashable {
    let x1, x2, y: Int

    init(_ position: Position) {
        self.x1 = position.x
        self.x2 = position.x + 1
        self.y = position.y
    }

    var positions: [Position] {
        [
            Position(x: x1, y: y),
            Position(x: x2, y: y)
        ]
    }

    func moved(in direction: Direction) -> WideBox {
        WideBox(Position(x: x1, y: y).position(in: direction))
    }

    func possibleBoxes(in direction: Direction) -> [WideBox] {
        switch direction {
        case .right: Position(x: x2, y: y).possibleBoxes(in: .right)
        case .left: Position(x: x1, y: y).possibleBoxes(in: .left)
        case .up, .down: positions.flatMap { $0.possibleBoxes(in: direction) }
        }
    }
}
