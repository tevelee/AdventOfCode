import Foundation
import Parsing

public final class AoC_2021_Day4 {
    let numbers: [Int]
    let boards: [[Cell]]

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ content: String) {
        let segments = content.paragraphs
        numbers = segments[0][0].split(separator: ",").map(String.init).compactMap(Int.init)
        boards = segments.dropFirst().map {
            $0.flatMap {
                $0.split(separator: " ")
                    .map(String.init)
                    .compactMap(Int.init)
                    .map { ($0, false) }
            }
        }
    }

    typealias Cell = (value: Int, marked: Bool)

    public func solvePart1() throws -> Int {
        var boards = boards
        for number in numbers {
            for (boardIndex, board) in boards.enumerated() {
                if let index = board.firstIndex(where: { $0.value == number }) {
                    boards[boardIndex][index].marked = true
                    let board = boards[boardIndex]
                    if isBingo(on: board) {
                        return board.filter(!\.marked).map(\.value).reduce(0, +) * number
                    }
                }
            }
        }
        return 0
    }


    public func solvePart2() throws -> Int {
        var boards = boards
        var winner: (number: Int, board: [Cell])?
        for number in numbers {
            var boardsToRemove: Set<Int> = []
            for (boardIndex, board) in boards.enumerated() {
                if let index = board.firstIndex(where: { $0.value == number }) {
                    boards[boardIndex][index].marked = true
                    let board = boards[boardIndex]
                    if isBingo(on: board) {
                        winner = (number, board)
                        boardsToRemove.insert(boardIndex)
                    }
                }
            }
            for index in boardsToRemove.sorted().reversed() {
                boards.remove(at: index)
            }
        }
        guard let winner = winner else { return 0 }
        return winner.board.filter(!\.marked).map(\.value).reduce(0, +) * winner.number
    }

    private let range = 0 ..< 5

    private func stringify(board: [Cell]) {
        for row in range {
            for column in range {
                print(board[row * 5 + column].marked ? "X" : ".", terminator: "")
            }
            print()
        }
    }

    private func isBingo(on board: [Cell]) -> Bool {
        range.contains { i in
            let row = range.map { board[i * 5 + $0] }
            let column = range.map { board[$0 * 5 + i] }
            return row.allSatisfy(\.marked) || column.allSatisfy(\.marked)
        }
    }
}

private extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
    return { !$0[keyPath: keyPath] }
}
