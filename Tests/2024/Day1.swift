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

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try await #expect(problem.solvePart1() == 2_375_403)
        try await #expect(problem.solvePart2() == 23_082_277)
    }
}
