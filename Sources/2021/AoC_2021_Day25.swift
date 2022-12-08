import Algorithms

public final class AoC_2021_Day25 {
    private enum Field: Character, RawRepresentable, Hashable {
        case south = "v"
        case east = ">"
        case empty = "."
    }

    private typealias Map = [[Field]]
    private let map: Map

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        map = input.lines.map { line in
            line.compactMap(Field.init)
        }
    }

    public func solvePart1() async throws -> Int {
        var map = self.map
        var numberOfSteps = 0
        while true {
            let east = moves(of: .east, on: map)
            perform(east, on: &map)
            let south = moves(of: .south, on: map)
            perform(south, on: &map)
            numberOfSteps += 1
            if east.isEmpty && south.isEmpty {
                return numberOfSteps
            }
        }
    }

    public func solvePart2() async throws -> Int {
        return 0
    }

    private func moves(of field: Field, on map: Map) -> [Position] {
        var moves: [Position] = []
        for (row, line) in map.enumerated() {
            for (column, current) in line.enumerated() where current == field {
                let position = (row, column)
                if canMove(at: position, on: map) {
                    moves.append(position)
                }
            }
        }
        return moves
    }

    private func nextPosition(from position: Position, on map: Map) -> Position? {
        switch map[position] {
            case .east:
                let row = position.row
                let numberOfColumns = map[position.row].count
                let column = (position.column + 1) % numberOfColumns
                return (row, column)
            case .south:
                let numberOfRows = map.count
                let row = (position.row + 1) % numberOfRows
                let column = position.column
                return (row, column)
            case .empty:
                return nil
        }
    }

    private func canMove(at position: (row: Int, column: Int), on map: Map) -> Bool {
        guard let next = nextPosition(from: position, on: map) else {
            return false
        }
        return map[next] == .empty
    }

    private func perform(_ moves: [Position], on map: inout Map) {
        let original = map
        for move in moves {
            let next = nextPosition(from: move, on: original)!
            map[move] = .empty
            map[next] = original[move]
        }
    }

    private func visualize(_ map: Map) {
        for line in map {
            print(String(line.map(\.rawValue)))
        }
        print()
    }
}

private typealias Position = (row: Int, column: Int)

private extension Array {
    subscript<T>(position: Position) -> T where Element == [T] {
        get {
            self[position.row][position.column]
        }
        set {
            self[position.row][position.column] = newValue
        }
    }
}
