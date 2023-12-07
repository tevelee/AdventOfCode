import Algorithms

final class AoC_2023_Day7 {
    private let entries: [Entry]

    init(_ input: Input) throws {
        entries = try input.wholeInput.lines.map(Entry.init)
    }

    func solvePart1() -> Int {
        solve(entries)
    }

    func solvePart2() -> Int {
        solve(entries.map(\.switchingJacksToJokers))
    }

    private func solve(_ entries: [Entry]) -> Int {
        zip(entries.sorted(by: \.hand).map(\.bet), 1...entries.count).sum { bet, rank in
            bet * rank
        }
    }
}

private struct Entry {
    let hand: Hand
    let bet: Int
}

private final class Hand {
    let cards: [Card]

    init(cards: [Card]) {
        self.cards = cards
    }

    lazy var type: `Type` = computeType()

    enum `Type`: Int, Equatable {
        case fiveOfAKind = 6
        case fourOfAKind = 5
        case fullHouse = 4
        case threeOfAKind = 3
        case twoPairs = 2
        case onePair = 1
        case highCard = 0
    }
}

private enum Card: Character, Equatable {
    case ace = "A"
    case king = "K"
    case queen = "Q"
    case jack = "J"
    case number10 = "T"
    case number9 = "9"
    case number8 = "8"
    case number7 = "7"
    case number6 = "6"
    case number5 = "5"
    case number4 = "4"
    case number3 = "3"
    case number2 = "2"
    case joker = "*"
}

extension Entry {
    init(rawString: String) throws {
        guard let match = rawString.wholeMatch(of: /((?<cards>[AKQJT2-9]{5}) (?<bet>\d+))/)?.output,
              let bet = Int(match.bet) else { throw ParseError() }
        self.hand = Hand(cards: match.cards.compactMap(Card.init))
        self.bet = bet
    }

    var switchingJacksToJokers: Entry {
        Entry(hand: hand.switchingJacksToJokers, bet: bet)
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        String(cards.map(\.rawValue))
    }
}

extension Hand: Equatable {
    static func == (lhs: Hand, rhs: Hand) -> Bool {
        lhs.cards == rhs.cards
    }
}

extension Hand: Comparable {
    static func < (lhs: Hand, rhs: Hand) -> Bool {
        guard lhs.type == rhs.type else {
            return lhs.type < rhs.type
        }
        for (lhs, rhs) in zip(lhs.cards, rhs.cards) where lhs != rhs {
            return lhs < rhs
        }
        return false
    }
}

extension Hand {
    var switchingJacksToJokers: Hand {
        if cards.contains(.jack) {
            Hand(cards: cards.map { $0 == .jack ? .joker : $0 })
        } else {
            self
        }
    }

    private func computeType() -> Hand.`Type` {
        var counts = Array(cards.grouped(by: \.rawValue).mapValues(\.count).values.sorted().reversed())
        accountForJokers(in: &counts)
        return switch counts {
        case [5]: .fiveOfAKind
        case [4, 1]: .fourOfAKind
        case [3, 2]: .fullHouse
        case [3, 1, 1]: .threeOfAKind
        case [2, 2, 1]: .twoPairs
        case [2, 1, 1, 1]: .onePair
        case [1, 1, 1, 1, 1]: .highCard
        default: fatalError("Invalid hand")
        }
    }

    private func accountForJokers(in counts: inout [Int]) {
        let numberOfJokers = cards.count { $0 == .joker }
        if (1...4).contains(numberOfJokers), let indexOfJoker = counts.firstIndex(of: numberOfJokers) {
            counts.remove(at: indexOfJoker)
            counts[0] += numberOfJokers
        }
    }
}

extension Hand.`Type`: Comparable {
    fileprivate static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Card: Comparable {
    static func < (lhs: Card, rhs: Card) -> Bool {
        lhs.value < rhs.value
    }
}

extension Card {
    private var value: Int {
        switch self {
        case .ace: 14
        case .king: 13
        case .queen: 12
        case .jack: 11
        case .number10: 10
        case .number9: 9
        case .number8: 8
        case .number7: 7
        case .number6: 6
        case .number5: 5
        case .number4: 4
        case .number3: 3
        case .number2: 2
        case .joker: 1
        }
    }
}
