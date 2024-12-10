import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day13
extension CurrentPuzzle: Puzzle {}

private struct Day13 {
    @Test
    func part1_intro() async throws {
        let problem = CurrentPuzzle("""
        """)
        try await #expect(problem.solvePart1() == 0)
    }

    @Test
    func part2_intro() async throws {
        let problem = CurrentPuzzle("""
        """)
        try await #expect(problem.solvePart2() == 0)
    }

    @Suite(.tags(.live), .serialized)
    struct Day13Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 13 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 0)
        }
        
        @Test("Day 13 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 0)
        }
    }
}
