import Algorithms
import Foundation
import OrderedCollections

public final class AoC_2021_Day15 {
    let board: [[Int]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ contents: String) {
        board = contents.lines.map { line in
            line.compactMap(\.wholeNumberValue)
        }
    }

    public func solvePart1() -> Int {
        let topLeft = board.firstPosition
        let bottomRight = board.lastPosition
        var paths: [Position: Path] = [:]
//        if let data = UserDefaults.standard.data(forKey: "paths"), let model = try? JSONDecoder().decode([Position: Path].self, from: data) {
//            paths = model
//        }
        traverseBreadthFirst(on: board, from: bottomRight) { position in
            let path = pathWithMinimumCost(on: board,
                                           start: position,
                                           end: bottomRight,
                                           knownMinimumPaths: paths)
            for (pathPosition, subPath) in path.subPaths(in: board) where paths[pathPosition] == nil {
                paths[pathPosition] = subPath
            }
            print(position, path.cost)
//            if let data = try? JSONEncoder().encode(paths) {
//                UserDefaults.standard.set(data, forKey: "paths")
//            }
        }
        print(paths[topLeft]!.elements.map(\.position))
        return paths[topLeft]!.cost - board[topLeft]
    }

    public func solvePart2() -> Int {
        0
    }

    private func traverseBreadthFirst(on board: [[Int]],
                                      from start: Position,
                                      perform action: (Position) -> Void) {
        var queue: OrderedSet<Position> = [start]
        var index = 0

        repeat {
            let position = queue[index]
            action(position)
            queue.append(contentsOf: adjacentPositions(for: position, in: board).filter { !queue.contains($0) })
            index += 1
        } while index != queue.endIndex
    }

    private func pathWithMinimumCost(on board: [[Int]],
                                     start: Position,
                                     end: Position,
                                     knownMinimumPaths: [Position: Path],
                                     minimumPath: Path? = nil,
                                     path: Path = Path()) -> Path {
        if let existing = knownMinimumPaths[start] {
            return path.appending(path: existing)
        }
        if let minimumPath = minimumPath, path.cost >= minimumPath.cost {
            return path.appending(path: minimumPath)
        }
        if start == end {
            return path.appending(position: start, cost: board[start])
        }
        let positions = adjacentPositions(for: start, in: board).filter { !path.contains(position: $0) }
        var localMinimumPath = minimumPath
        for position in positions {
            let minimumPath = pathWithMinimumCost(on: board,
                                                  start: position,
                                                  end: end,
                                                  knownMinimumPaths: knownMinimumPaths,
                                                  minimumPath: localMinimumPath,
                                                  path: path.appending(position: start, cost: path.cost + board[start]))
            if localMinimumPath.map({ minimumPath.cost < $0.cost }) ?? true {
                localMinimumPath = minimumPath
            }
        }
        return localMinimumPath!
    }

    private func adjacentPositions(for position: Position, in board: [[Int]]) -> [Position] {
        var result: [Position] = []
        if position.row < board.count - 1 {
            result.append(Position(row: position.row + 1, column: position.column))
        }
        if position.column < board[0].count - 1 {
            result.append(Position(row: position.row, column: position.column + 1))
        }
//        if position.row > 0 {
//            result.append(Position(row: position.row - 1, column: position.column))
//        }
//        if position.column > 0 {
//            result.append(Position(row: position.row, column: position.column - 1))
//        }
        return result
    }
}

private struct Position: Hashable, Codable, CustomStringConvertible {
    let row: Int
    let column: Int

    var description: String { "(\(row), \(column))" }
}

private struct Path: Hashable, Codable {
    var elements: OrderedSet<PathElement> = []
    private(set) var cost: Int = 0

    func contains(position: Position) -> Bool {
        for element in elements where element.position == position {
            return true
        }
        return false
    }

    func appending(position: Position, cost: Int) -> Path {
        var new = self
        new.append(element: PathElement(position: position, cost: cost))
        return new
    }

    mutating func append(element: PathElement) {
        elements.append(element)
        cost += element.cost
    }

    func appending(path: Path) -> Path {
        var new = self
        new.elements.append(contentsOf: path.elements)
        new.cost += path.cost
        return new
    }

    func subPaths(in board: [[Int]]) -> [Position: Path] {
        var elements: OrderedSet<PathElement> = []
        var cost = 0

        var result: [Position: Path] = [:]
        for element in self.elements.reversed() {
            elements.insert(element, at: 0)
            cost += board[element.position]
            result[element.position] = Path(elements: elements, cost: cost)
        }
        return result
    }
}

private struct PathElement: Hashable, Codable {
    let position: Position
    let cost: Int
}

private extension Array where Element == [Int] {
    var firstPosition: Position {
        Position(row: 0, column: 0)
    }

    var lastPosition: Position {
        Position(row: count - 1, column: self[0].count - 1)
    }

    subscript(position: Position) -> Int {
        get {
            self[position.row][position.column]
        }
        set {
            self[position.row][position.column] = newValue
        }
    }
}
