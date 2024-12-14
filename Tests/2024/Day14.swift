import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day14
extension CurrentPuzzle: Puzzle {}

private struct Day14 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        p=0,4 v=3,-3
        p=6,3 v=-1,-3
        p=10,3 v=-1,2
        p=2,0 v=2,-1
        p=0,0 v=1,3
        p=3,0 v=-2,-2
        p=7,6 v=-1,-3
        p=3,0 v=-1,-2
        p=9,3 v=2,3
        p=7,3 v=-1,2
        p=2,4 v=2,-3
        p=9,5 v=-3,-3
        """)
        #expect(problem.solvePart1(width: 11, height: 7) == 12)
    }

    @Suite(.tags(.live), .serialized)
    struct Day14Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 14 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 228_690_000)
        }
        
        @Test("Day 14 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 7_093)
        }
    }
}
