import Algorithms

private let energyRequirement = ["A": 1, "B": 10, "C": 100, "D": 1000]
private let homes = ["A": 0, "B": 1, "C": 2, "D": 3]
private let entrances = [2, 4, 6, 8]

public final class AoC_2021_Day23 {
    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    let input: String

    public init(_ input: String) {
        self.input = input
    }

    public func solvePart1() async throws -> Int {
        solve(lines: Array(input.lines))
    }

    public func solvePart2() async throws -> Int {
        var lines = Array(input.lines)
        let appendix = """
          #D#C#B#A#
          #D#B#A#C#
        """
        lines.insert(contentsOf: appendix.lines, at: 3)
        return solve(lines: lines)
    }

    private func solve(lines: [String]) -> Int {
        let (burrows, numberOfHallways) = parse(lines: lines)
        return minEnergyRequired(burrows: burrows, numberOfHallways: numberOfHallways)
    }

    private func parse(lines: [String]) -> (burrows: [[String]], numberOfHallways: Int) {
        let rawInput: [[Character]] = lines.map(Array.init)
        let reduced = rawInput.dropFirst().dropLast().map {
            Array($0.dropFirst().dropLast())
        }
        let burrows = entrances.map { column in
            (1 ..< reduced.count).map { row in
                String(reduced[row][column])
            }
        }
        let numberOfHallways = reduced[0].count
        return (burrows, numberOfHallways)
    }

    private func minEnergyRequired(burrows: [[String]], numberOfHallways: Int) -> Int {
        var states = [State(burrows: burrows, hallway: Array(repeating: "", count: numberOfHallways)): 0]
        var seen: Set<State> = []
        while !states.keys.allSatisfy({ $0.isComplete || seen.contains($0) }) {
            for (state, score) in states.filter({ !$0.key.isComplete && !seen.contains($0.key) }) {
                for (newState, score) in state.nextMoves(score: score) {
                    if score < states[newState, default: Int.max] {
                        states[newState] = score
                        if !newState.isComplete {
                            seen.remove(newState)
                        }
                    }
                }
                seen.insert(state)
            }
        }

        return states
            .filter(\.key.isComplete)
            .map(\.value)
            .min() ?? 0
    }

    private struct State: Hashable, Equatable {
        let burrows: [[String]]
        let hallway: [String]

        var isComplete: Bool {
            burrows.enumerated().allSatisfy { burrow in
                burrow.element.allSatisfy { homes[$0] == burrow.offset }
            }
        }

        func nextMoves(score: Int) -> [State: Int] {
            var moves: [State: Int] = [:]
            guard !isComplete else {
                return moves
            }
            burrows
                .enumerated()
                .filter { burrow in !burrow.element.allSatisfy { homes[$0] == burrow.offset } }
                .compactMap { burrow in
                    burrow.element.enumerated()
                        .first { $0.element != "" }
                        .map { (burrow.offset, $0) }
                }
                .forEach { (entrance, amphipod) in
                    var burrows = self.burrows
                    burrows[entrance][amphipod.offset] = ""
                    let entranceOffset = entrances[entrance]
                    for i in (0..<entranceOffset).reversed() {
                        if hallway[i] != "" {
                            break
                        }
                        if entrances.contains(i) {
                            continue
                        }
                        var hallway = self.hallway
                        hallway[i] = amphipod.element
                        let newState = State(burrows: burrows, hallway: hallway)
                        moves[newState] = (amphipod.offset + 1 + entranceOffset - i) * energyRequirement[amphipod.element, default: 0] + score
                    }
                    for i in (entranceOffset + 1) ..< hallway.count {
                        if hallway[i] != "" {
                            break
                        }
                        if entrances.contains(i) {
                            continue
                        }
                        var hallway = self.hallway
                        hallway[i] = amphipod.element
                        let newState = State(burrows: burrows, hallway: hallway)
                        moves[newState] = (amphipod.offset + 1 + i - entranceOffset) * energyRequirement[amphipod.element, default: 0] + score
                    }
                }
            hallway
                .enumerated()
                .filter { $0.element != "" }
                .forEach { amphipod in
                    let home = homes[amphipod.element, default: 0]
                    let entrance = entrances[home]
                    var burrows = self.burrows
                    guard burrows[home].allSatisfy({ $0 == amphipod.element || $0 == "" }) else { return }
                    var hallway = self.hallway
                    for i in (amphipod.offset < entrance ? (amphipod.offset + 1)..<entrance : entrance..<amphipod.offset) {
                        if hallway[i] != "" {
                            return
                        }
                    }
                    hallway[amphipod.offset] = ""
                    var steps = abs(amphipod.offset - entrances[home])
                    for (i, c) in burrows[home].enumerated().reversed() {
                        guard c == "" else { continue }
                        burrows[home][i] = amphipod.element
                        steps += i + 1
                        break
                    }
                    let newState = State(burrows: burrows, hallway: hallway)
                    moves[newState] = steps * energyRequirement[amphipod.element, default: 0] + score
                }
            return moves
        }
    }
}
