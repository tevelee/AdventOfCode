import Foundation
import Algorithms

public final class AoC_2021_Day21 {
    private let player1: Int
    private let player2: Int
    private let board: Board = Rolling(range: 1...10).makeIterator()

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        let lines = input.components(separatedBy: "\n")
        player1 = Int(lines[0].replacingOccurrences(of: "Player 1 starting position: ", with: ""))!
        player2 = Int(lines[1].replacingOccurrences(of: "Player 2 starting position: ", with: ""))!
    }

    public func solvePart1() async throws -> Int {
        let threshold = 1000
        let rolls = Rolling(range: 1...100).chunks(ofCount: 3)
        var players = [Player(position: player1), Player(position: player2)]
        var round = 0
        for roll in rolls {
            let sum = roll.reduce(0, +)
            let player = round % players.count
            players[player].move(by: sum, on: board)
            round += 1
            if players[player].score >= threshold {
                let player = round % players.count
                let score = players[player].score
                let rolls = round * 3
                return score * rolls
            }
        }
        return 0
    }

    private lazy var sums: [Int: Int] = {
        sumOfNextRolls(in: 1...3).dictionary { $0 }.mapValues(\.count)
    }()

    public func solvePart2() async throws -> Int {
        let players = [Player(position: player1), Player(position: player2)]
        var results: [Int: Int] = [:]
        var winnerStates: [State: Int] = [:]
        spawnUniverses(for: players, into: &results, winnerStates: &winnerStates)
        return results.values.max()!
    }

    private func spawnUniverses(for players: [Player], on round: Int = 0, into results: inout [Int: Int], winnerStates: inout [State: Int]) {
        for (sum, occurences) in sums {
            play(round: round, multiplier: occurences, sum: sum, players: players, results: &results, winnerStates: &winnerStates)
        }
    }

    private func play(round: Int, multiplier: Int, sum: Int, players: [Player], results: inout [Int: Int], winnerStates: inout [State: Int]) {
        let playerIndex = round % players.count
//        let player = players[playerIndex]
//        let state = State(playerIndex: playerIndex, sum: sum, players: players)
//        if let value = winnerStates[state] {
//            results[playerIndex, default: 0] += value * multiplier
//            return
//        }
        var mutatedPayers = players
        mutatedPayers[playerIndex].move(by: sum, on: board)
        if mutatedPayers[playerIndex].score >= 21 {
            results[playerIndex, default: 0] += multiplier
//            winnerStates[state] = multiplier
            return
        }
        spawnUniverses(for: mutatedPayers, on: round + 1, into: &results, winnerStates: &winnerStates)
    }

    private func sumOfNextRolls(in range: ClosedRange<Int>) -> [Int] {
        product(product(range, range), range).map { p, c -> Int in
            let (a,b) = p
            return a+b+c
        }
    }

    private struct State: Hashable {
        let playerIndex: Int
        let sum: Int
        let players: [Player]
    }

    private struct Player: Hashable {
        var score: Int = 0
        var position: Int

        mutating func move(by moves: Int, on board: Board) {
            position = board.advanced(by: moves, from: position)
            score += position
        }
    }
}

private protocol Board {
    func advanced(by amount: Int, from position: Int) -> Int
}

private struct Rolling: Sequence {
    typealias Element = Int

    let range: ClosedRange<Int>

    func makeIterator() -> Iterator {
        Iterator(range: range)
    }

    struct Iterator: IteratorProtocol, Board {
        typealias Element = Int

        let range: ClosedRange<Int>
        var i = 0

        mutating func next() -> Int? {
            defer { i += 1 }
            return advanced(by: i, from: range.lowerBound)
        }

        func advanced(by amount: Int, from position: Int) -> Int {
            range.lowerBound + (position - range.lowerBound + amount) % range.count
        }
    }
}

private extension Sequence {
    func chunks(ofCount size: Int) -> ChunkedByCount<Self> {
        ChunkedByCount(base: self, size: size)
    }
}

private struct ChunkedByCount<Base: Sequence>: Sequence {
    typealias Element = [Base.Element]

    let base: Base
    let size: Int

    func makeIterator() -> Iterator<Base.Iterator> {
        Iterator(base: base.makeIterator(), size: size)
    }

    struct Iterator<Base: IteratorProtocol>: IteratorProtocol {
        typealias Element = [Base.Element]

        var base: Base
        let size: Int

        mutating func next() -> [Base.Element]? {
            var result: [Base.Element] = []
            while result.count < size, let value = base.next() {
                result.append(value)
            }
            return result
        }
    }
}

private func +<Key: Hashable, Value: Numeric>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    var result = lhs
    result += rhs
    return result
}

private func +=<Key: Hashable, Value: Numeric>(lhs: inout [Key: Value], rhs: [Key: Value]) {
    for (key, value) in rhs {
        lhs[key, default: 0] += value
    }
}
