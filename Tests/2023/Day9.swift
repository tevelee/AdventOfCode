@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day9
extension CurrentPuzzle: Puzzle {}

private struct Day9 {
    @Test
    func intro() async throws {
        let problem = CurrentPuzzle("""
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
        """)
        #expect(try await problem.solvePart1() == 114)
        #expect(try await problem.solvePart2() == 2)
    }

    @Test(.tags(.green))
    func live() async throws {
        let problem = try CurrentPuzzle()
        #expect(try await problem.solvePart1() == 1_930_746_032)
        #expect(try await problem.solvePart2() == 1154)
    }
}
