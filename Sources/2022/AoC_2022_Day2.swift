public final class AoC_2022_Day2 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        try await entries()
            .compactMap { first, second -> (opponentsMove: Move, myMove: Move)? in
                guard let opponentsMove = Move(opponentsMove: first),
                      let myMove = Move(myMove: second) else {
                    return nil
                }
                return (opponentsMove, myMove)
            }
            .sum { opponentsMove, myMove in
                myMove.score(against: opponentsMove)
            }
    }

    public func solvePart2() async throws -> Int {
        try await entries()
            .compactMap { first, second -> (move: Move, outcome: Outcome)? in
                guard let opponentsMove = Move(opponentsMove: first),
                      let outcome = Outcome(second) else {
                    return nil
                }
                return (opponentsMove, outcome)
            }
            .sum { opponentsMove, outcome in
                let myMove = opponentsMove.move(for: outcome)
                return myMove.score(against: opponentsMove)
            }
    }

    private func entries() -> AnyAsyncSequence<(Character, Character)> {
        input.lines
            .compactMap { line in
                guard let components = line.wholeMatch(of: /(\w) (\w)/)?.output,
                      let firstSymbol = components.1.first,
                      let secondSymbol = components.2.first else {
                    return nil
                }
                return (firstSymbol, secondSymbol)
            }
            .eraseToAnyAsyncSequence()
    }
}

private enum Outcome {
    case win
    case draw
    case lose

    init?(_ character: Character) {
        switch character {
        case "X": self = .lose
        case "Y": self = .draw
        case "Z": self = .win
        default: return nil
        }
    }

    var score: Int {
        switch self {
        case .win: return 6
        case .draw: return 3
        case .lose: return 0
        }
    }
}

private enum Move {
    case rock
    case paper
    case scissors

    init?(myMove move: Character) {
        switch move {
        case "X": self = .rock
        case "Y": self = .paper
        case "Z": self = .scissors
        default: return nil
        }
    }

    init?(opponentsMove move: Character) {
        switch move {
        case "A": self = .rock
        case "B": self = .paper
        case "C": self = .scissors
        default: return nil
        }
    }

    private func outcome(against move: Move) -> Outcome {
        switch (self, move) {
        case let (this, that) where this == that: return .draw
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock): return .win
        default: return .lose
        }
    }

    private var standaloneScore: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }

    func score(against move: Move) -> Int {
        standaloneScore + outcome(against: move).score
    }

    func move(for outcome: Outcome) -> Move {
        switch (self, outcome) {
        case (let move, .draw): return move
        case (.rock, .win), (.scissors, .lose): return .paper
        case (.paper, .win), (.rock, .lose): return .scissors
        case (.scissors, .win), (.paper, .lose): return .rock
        }
    }
}
