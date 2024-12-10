import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day12
extension CurrentPuzzle: Puzzle {}

private struct Day12 {
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
    struct Day12Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 12 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 0)
        }
        
        @Test("Day 12 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 0)
        }
    }
}
