import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day9
extension CurrentPuzzle: Puzzle {}

private struct Day9 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        7,1
        11,1
        11,7
        9,7
        9,5
        2,5
        2,3
        7,3
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 50)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 24)
    }

    @Suite(.tags(.live), .serialized)
    struct Day9Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 9 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 4_733_727_792)
        }
        
        @Test("Day 9 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 1_566_346_198)
        }
    }
}
