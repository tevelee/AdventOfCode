import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day10
extension CurrentPuzzle: Puzzle {}

private struct Day10 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 7)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 33)
    }

    @Suite(.tags(.live), .serialized)
    struct Day10Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 10 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 505)
        }
        
        @Test("Day 10 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 0)
        }
    }
}
