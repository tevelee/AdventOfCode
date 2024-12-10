import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day1
extension CurrentPuzzle: Puzzle {}

private struct Day1 {
    @Test
    func part1_intro() async throws {
        let problem = try await CurrentPuzzle("""
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """)
        try await #expect(problem.solvePart1() == 11)
    }

    @Test
    func part2_intro() async throws {
        let problem = try await CurrentPuzzle("""
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """)
        try await #expect(problem.solvePart2() == 31)
    }

    @Suite(.tags(.live), .serialized)
    struct Day1Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 1 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 2_375_403)
        }

        @Test("Day 1 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 23_082_277)
        }
    }
}

