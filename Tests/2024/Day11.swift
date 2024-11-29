import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day11
extension CurrentPuzzle: Puzzle {}

private struct Day11 {
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

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try await #expect(problem.solvePart1() == 0)
        try await #expect(problem.solvePart2() == 0)
    }
}
