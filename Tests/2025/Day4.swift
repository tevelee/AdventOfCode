import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day4
extension CurrentPuzzle: Puzzle {}

private struct Day4 {
    let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        ..@@.@@@@.
        @@@.@.@.@@
        @@@@@.@.@@
        @.@@@@..@.
        @@.@@@@.@@
        .@@@@@@@.@
        .@.@.@.@@@
        @.@@@.@@@@
        .@@@@@@@@.
        @.@.@@@.@.
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 13)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 43)
    }

    @Suite(.tags(.live), .serialized)
    struct Day4Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 4 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 1_441)
        }
        
        @Test("Day 4 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 9_050)
        }
    }
}
