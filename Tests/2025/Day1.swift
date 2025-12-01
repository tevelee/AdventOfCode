import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day1
extension CurrentPuzzle: Puzzle {}

private struct Day1 {
    @Test
    func part1_intro() async throws {
        let problem = CurrentPuzzle("""
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """)
        try await #expect(problem.solvePart1() == 3)
    }

    @Test
    func part2_intro() async throws {
        let problem = CurrentPuzzle("""
        L68
        L30
        R48
        L5
        R60
        L55
        L1
        L99
        R14
        L82
        """)
        try await #expect(problem.solvePart2() == 6)
    }

    @Suite(.tags(.live), .serialized)
    struct Day1Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 1 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 1147)
        }
        
        @Test("Day 1 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 6789)
        }
    }
}
