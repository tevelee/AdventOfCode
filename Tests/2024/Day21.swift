import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day21
extension CurrentPuzzle: Puzzle {}

private struct Day21 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        029A
        980A
        179A
        456A
        379A
        """)
        #expect(problem.solvePart1() == 126_384)
    }

    @Suite(.tags(.live), .serialized)
    struct Day21Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 21 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 157_892)
        }
        
        @Test("Day 21 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 197_015_606_336_332)
        }
    }
}
