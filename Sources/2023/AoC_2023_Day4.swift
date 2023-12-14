import Algorithms

final class AoC_2023_Day4 {
    private let cards: [Card]

    init(_ input: Input) throws {
        cards = try input.wholeInput.lines.compactMap(Card.init)
    }

    func solvePart1() -> Int {
        cards.sum { card in
            pow(card.numberOfMatches, base: 2) / 2
        }
    }

    func solvePart2() -> Int {
        var instances: [Int: Int] = cards.indices.grouped { $0 }.mapValues { _ in 1 }
        for (offset, card) in self.cards.enumerated() {
            let multiplier = instances[offset, default: 1]
            for additional in 0..<card.numberOfMatches {
                instances[offset + additional + 1, default: 1] += multiplier
            }
        }
        return instances.sum(of: \.value)
    }
}

private struct Card {
    let id: Int
    let winnerNumbers: [Int]
    let allNumbers: [Int]

    init?(rawString: String) {
        guard let values = rawString.wholeMatch(of: /Card.*?(?<id>\d+): (?<winning>.*?) \| (?<all>.*)/)?.output,
              let id = Int(values.id) else {
            return nil
        }
        self.id = id
        self.winnerNumbers = values.winning.integers
        self.allNumbers = values.all.integers
    }

    var numberOfMatches: Int {
        Set(allNumbers).intersection(Set(winnerNumbers)).count
    }
}
