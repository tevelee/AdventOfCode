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

    @Suite(.tags(.live), .serialized)
    struct Day25Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 25")
        func live() async throws {
            try await #expect(problem.solve() == 0)
        }
    }
}
