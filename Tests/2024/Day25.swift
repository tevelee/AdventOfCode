import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day25
extension CurrentPuzzle: Puzzle {}

private struct Day25 {
    @Test
    func intro() async throws {
        let problem = CurrentPuzzle("""
        """)
        try await #expect(problem.solve() == 0)
    }

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try await #expect(problem.solve() == 0)
    }
}
