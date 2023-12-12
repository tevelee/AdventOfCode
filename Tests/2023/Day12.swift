@testable import AoC_2023
import Testing

struct Day12 {
    @Test
    func intro1() async throws {
        let problem = AoC_2023_Day12("""
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
        let problem = try AoC_2023_Day12()
        #expect(try await problem.solvePart1() == 7653)
        #expect(try await problem.solvePart2() == 60_681_419_004_564)
    }
}
