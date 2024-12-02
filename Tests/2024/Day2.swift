import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day2
extension CurrentPuzzle: Puzzle {}

private struct Day2 {
    @Test
    func part1_intro() async throws {
        let problem = CurrentPuzzle("""
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """)
        try await #expect(problem.solvePart1() == 2)
    }

    @Test
    func part2_intro() async throws {
        let problem = CurrentPuzzle("""
        7 6 4 2 1
        1 2 7 8 9
        9 7 6 2 1
        1 3 2 4 5
        8 6 4 4 1
        1 3 6 7 9
        """)
        try await #expect(problem.solvePart2() == 4)
    }

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try await #expect(problem.solvePart1() == 220)
        try await #expect(problem.solvePart2() == 296)
    }
}
