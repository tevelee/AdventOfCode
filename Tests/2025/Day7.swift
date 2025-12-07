import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day7
extension CurrentPuzzle: Puzzle {}

private struct Day7 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        .......S.......
        ...............
        .......^.......
        ...............
        ......^.^......
        ...............
        .....^.^.^.....
        ...............
        ....^.^...^....
        ...............
        ...^.^...^.^...
        ...............
        ..^...^.....^..
        ...............
        .^.^.^.^.^...^.
        ...............
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 21)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 40)
    }

    @Suite(.tags(.live), .serialized)
    struct Day7Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 7 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 1_507)
        }
        
        @Test("Day 7 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 1_537_373_473_728)
        }
    }
}
