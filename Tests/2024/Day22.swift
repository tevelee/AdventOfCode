import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day22
extension CurrentPuzzle: Puzzle {}

private struct Day22 {
    @Test
    func part1_intro() async throws {
        let problem = CurrentPuzzle("""
        1
        10
        100
        2024
        """)
        try await #expect(problem.solvePart1() == 37_327_623)
    }

    @Test
    func part2_intro() async throws {
        let problem = CurrentPuzzle("""
        1
        2
        3
        2024
        """)
        try await #expect(problem.solvePart2() == 23)
    }

    @Suite(.tags(.live), .serialized)
    struct Day22Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 22 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 19_927_218_456)
        }
        
        @Test("Day 22 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 2_189)
        }
    }
}
