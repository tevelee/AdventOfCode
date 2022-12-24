import Utils
import Algorithms

public final class AoC_2022_Day22 {
    private let map: Map
    private let instructions: [Instruction]

    public init(_ input: Input) throws {
        let paragraphs = try input.wholeInput.paragraphs
        guard let mapInput = paragraphs.first, let instructionsInput = paragraphs.last?.first else {
            throw ParseError()
        }
        map = try .init(from: mapInput)
        instructions = try .init(from: instructionsInput)
    }

    private lazy var initialState = State(tile: map.topLeft, facing: .right)

    public func solvePart1() -> Int {
        solve(with: WrapAround(on: map))
    }

    public func solvePart2() -> Int {
        solve(with: Cube(from: map))
    }

    private func solve(with strategy: MovingStrategy) -> Int {
        map.perform(instructions, initialState: initialState, movingStrategy: strategy).score
    }
}

private struct Position: Hashable, CustomStringConvertible {
    var row, column: Int

    func neighborPosition(in direction: Direction) -> Position {
        switch direction {
        case .left:
            return Position(row: row, column: column - 1)
        case .right:
            return Position(row: row, column: column + 1)
        case .up:
            return Position(row: row - 1, column: column)
        case .down:
            return Position(row: row + 1, column: column)
        }
    }

    var description: String { "(\(row),\(column))" }
}

private struct Tile: Hashable {
    let position: Position
    let isWall: Bool

    var score: Int {
        1000 * (position.row + 1) + 4 * (position.column + 1)
    }
}

private struct State: Hashable {
    var tile: Tile
    var facing: Direction

    var score: Int {
        tile.score + facing.rawValue
    }

    func applying(block: (inout State) -> Void) -> State {
        var copy = self
        block(&copy)
        return copy
    }
}

private protocol MovingStrategy {
    func moveForward(from state: State) -> State
}

private struct WrapAround: MovingStrategy {
    private let map: Map

    init(on map: Map) {
        self.map = map
    }

    func moveForward(from state: State) -> State {
        let tile = moveForward(from: state.tile, in: state.facing)
        return state.applying { $0.tile = tile }
    }

    private func moveForward(from tile: Tile, in direction: Direction) -> Tile {
        let newPosition = tile.position.neighborPosition(in: direction)
        if let tile = map.tile(at: newPosition) {
            return tile
        } else {
            var tile = tile
            while true {
                let nextPosition = tile.position.neighborPosition(in: direction.opposite)
                if let nextTile = map.tile(at: nextPosition) {
                    tile = nextTile
                } else {
                    return tile
                }
            }
        }
    }
}

private struct Cube: MovingStrategy {
    private let map: Map
    private let size: Int
    private let sides: [Position: (side: Side, topEdge: Character)]

    private enum Side: String, CaseIterable {
        case front = "EBIA"
        case back = "GDKC"
        case top = "GFEH"
        case bottom = "IJKL"
        case left = "HALD"
        case right = "FCJB"

        func commonEdge(with other: Side) -> Character? {
            Set(rawValue).intersection(Set(other.rawValue)).first
        }

        func side(in direction: Direction, topEdge: Character) -> (side: Side, commonEdge: Character, topEdge: Character) {
            let rotations: [Direction: Int] = [
                .up: 0,
                .right: 1,
                .down: 2,
                .left: 3
            ]
            let currentEdges = Array(rawValue)
            let indexOfTopEdge = currentEdges.firstIndex(of: topEdge)!
            let commonEdgeIndex = nonNegativeModulo(of: indexOfTopEdge + rotations[direction, default: 0], by: 4)
            let commonEdge = currentEdges[commonEdgeIndex]
            let side = Side.allCases.first { $0 != self && $0.rawValue.contains(commonEdge) }!
            let newEdges = Array(side.rawValue)
            let indexOfCommonEdge = newEdges.firstIndex(of: commonEdge)!
            let newTopIndex = nonNegativeModulo(of: indexOfCommonEdge - rotations[direction.opposite, default: 0], by: 4)
            let newTopEdge = newEdges[newTopIndex]
            return (side, commonEdge, newTopEdge)
        }
    }

    init(from map: Map) {
        size = Int(sqrt(Double(map.numberOfTiles) / 6))
        self.map = map
        var sides: [Position: (side: Side, topEdge: Character)] = [:]
        Self.discoverNeighbors(of: map.topLeft.position, side: .front, topEdge: "E", on: map, size: size, into: &sides)
        precondition(sides.count == 6)
        self.sides = sides
    }

    private static func discoverNeighbors(of position: Position,
                                          side: Side,
                                          topEdge: Character,
                                          on map: Map,
                                          size: Int,
                                          into sides: inout [Position: (side: Side, topEdge: Character)]) {
        guard sides[position] == nil else {
            return
        }
        sides[position] = (side, topEdge)
        discoverNeighbors(of: Position(row: position.row, column: position.column - size),
                          in: .left,
                          side: side,
                          topEdge: topEdge,
                          on: map,
                          size: size,
                          into: &sides)
        discoverNeighbors(of: Position(row: position.row, column: position.column + size),
                          in: .right,
                          side: side,
                          topEdge: topEdge,
                          on: map,
                          size: size,
                          into: &sides)
        discoverNeighbors(of: Position(row: position.row + size, column: position.column),
                          in: .down,
                          side: side,
                          topEdge: topEdge,
                          on: map,
                          size: size,
                          into: &sides)
        discoverNeighbors(of: Position(row: position.row - size, column: position.column),
                          in: .up,
                          side: side,
                          topEdge: topEdge,
                          on: map,
                          size: size,
                          into: &sides)
    }

    private static func discoverNeighbors(of position: Position,
                                          in direction: Direction,
                                          side: Side,
                                          topEdge: Character,
                                          on map: Map,
                                          size: Int,
                                          into sides: inout [Position: (side: Side, topEdge: Character)]) {
        if sides[position] == nil, let tile = map.tile(at: position) {
            let (newSide, commmonEdge, newTopEdge) = side.side(in: direction, topEdge: topEdge)
            print("From \(side) side with top edge \(topEdge)")
            print("Moves \(direction) through edge \(commmonEdge)")
            print("To \(newSide) side with top edge \(newTopEdge) (where top left is at \(position))")
            print("-")
            discoverNeighbors(of: tile.position,
                              side: newSide,
                              topEdge: newTopEdge,
                              on: map,
                              size: size,
                              into: &sides)
        }
    }

    private func side(of position: Position) -> (side: Side, topEdge: Character) {
        let row = Int(position.row / size) * size
        let column = Int(position.column / size) * size
        let position = Position(row: row, column: column)
        return sides[position]!
    }

    func moveForward(from state: State) -> State {
        let position = state.tile.position
        let side = self.side(of: position)
        let newPosition = position.neighborPosition(in: state.facing)
        if let tile = map.tile(at: newPosition) {
            let newSide = self.side(of: newPosition)
            if side == newSide {
                print("Going \(state.facing) at \(newPosition)")
            } else {
                let edge = side.side.commonEdge(with: newSide.side)!
                print("Going \(state.facing) through edge \(edge) to \(newSide.side) side at \(newPosition)")
            }
            return State(tile: tile, facing: state.facing)
        } else {
            let (newSide, commonEdge, _) = side.side.side(in: state.facing, topEdge: side.topEdge)
            let storedSide = sides.first { $0.value.side == newSide }!

            let offset: Int
            switch state.facing {
            case .left:
                offset = size - 1 - position.row % size
            case .right:
                offset = position.row % size
            case .up:
                offset = position.column % size
            case .down:
                offset = size - 1 - position.column % size
            }

            let direction = self.direction(onSide: newSide, topEdge: storedSide.value.topEdge, through: commonEdge)
            var adjustedPosition = storedSide.key // top left of new side
            switch direction {
            case .up:
                adjustedPosition.row += size - 1
                adjustedPosition.column += offset
            case .down:
                adjustedPosition.column += size - 1 - offset
            case .right:
                adjustedPosition.row += offset
            case .left:
                adjustedPosition.row += size - 1 - offset
                adjustedPosition.column += size - 1
            }

            print("Going \(state.facing) through edge \(commonEdge) to \(newSide) side at \(adjustedPosition) instead of \(newPosition). Now facing \(direction)")
            return State(tile: map.tile(at: adjustedPosition)!, facing: direction)
        }
    }

    private func direction(onSide side: Side, topEdge: Character, through commonEdge: Character) -> Direction {
        var direction = Direction.down
        let currentEdges = Array(side.rawValue)
        let indexOfTopEdge = currentEdges.firstIndex(of: topEdge)!
        var offset = 0
        while currentEdges[nonNegativeModulo(of: indexOfTopEdge + offset, by: 4)] != commonEdge {
            offset += 1
            direction.apply(rotation: .clockwise)
        }
        return direction
    }
}

private struct Map {
    private let tiles: [Position: Tile]
    var topLeft: Tile

    var numberOfTiles: Int { tiles.count }

    init(from lines: [String]) throws {
        var tiles: [Position: Tile] = [:]
        var topLeft: Tile?
        for (row, line) in lines.enumerated() {
            for (column, character) in line.enumerated() where !character.isWhitespace {
                let position = Position(row: row, column: column)
                if character == "." {
                    let tile = Tile(position: position, isWall: false)
                    tiles[position] = tile
                    if topLeft == nil {
                        topLeft = tile
                    }
                } else if character == "#" {
                    let tile = Tile(position: position, isWall: true)
                    tiles[position] = tile
                } else {
                    throw ParseError()
                }
            }
        }
        self.tiles = tiles
        guard let topLeft else {
            throw ParseError()
        }
        self.topLeft = topLeft
    }

    func tile(at position: Position) -> Tile? {
        tiles[position]
    }

    func perform(_ instructions: [Instruction], initialState: State, movingStrategy: MovingStrategy) -> State {
        var state = initialState
        for instruction in instructions {
            switch instruction {
            case let .turn(rotation):
                state.facing.apply(rotation: rotation)
            case let .moveForward(amount):
                for _ in 1...amount {
                    let newState = movingStrategy.moveForward(from: state)
                    if newState.tile.isWall {
                        break
                    } else {
                        state = newState
                    }
                }
            }
        }
        return state
    }
}

private extension Array where Element == Instruction {
    init(from input: String) throws {
        self = try input.chunked(on: \.isWholeNumber).map { isNumeric, value in
            if isNumeric, let value = Int(value) {
                return .moveForward(amount: value)
            } else if let rotation = value.first.flatMap(Rotation.init) {
                return .turn(rotation: rotation)
            } else {
                throw ParseError()
            }
        }
    }
}

private struct ParseError: Error {}

private enum Instruction {
    case moveForward(amount: Int)
    case turn(rotation: Rotation)
}

private enum Rotation: Character {
    case clockwise = "R"
    case counterClockwise = "L"
}

private enum Direction: Int, CaseIterable {
    case right = 0
    case down = 1
    case left = 2
    case up = 3

    mutating func apply(rotation: Rotation) {
        var rawValue = self.rawValue
        switch rotation {
        case .clockwise: rawValue += 1
        case .counterClockwise: rawValue -= 1
        }
        self = Direction(rawValue: rawValue)
    }

    init(rawValue value: Int) {
        let cases = Self.allCases
        let rawValue = nonNegativeModulo(of: value, by: cases.count)
        self = cases.first { $0.rawValue == rawValue }!
    }

    var opposite: Direction {
        switch self {
        case .right: return .left
        case .left: return .right
        case .up: return .down
        case .down: return .up
        }
    }
}
