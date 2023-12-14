@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day12
extension CurrentPuzzle: Puzzle {}

private struct Day12 {
    @Test
    func intro() async throws {
        let problem = CurrentPuzzle("""
        ???.### 1,1,3
        .??..??...?##. 1,1,3
        ?#?#?#?#?#?#?#? 1,3,1,6
        ????.#...#... 4,1,1
        ????.######..#####. 1,6,5
        ?###???????? 3,2,1
        """)
        #expect(try await problem.solvePart1() == 21)
        #expect(try await problem.solvePart2() == 525_152)
    }

    @Test(.tags(.green))
    func live() async throws {
        let problem = try CurrentPuzzle()
        #expect(try await problem.solvePart1() == 7653)
        #expect(try await problem.solvePart2() == 60_681_419_004_564)
    }
}
