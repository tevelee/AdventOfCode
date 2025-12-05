import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day5
extension CurrentPuzzle: Puzzle {}

private struct Day5 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        3-5
        10-14
        16-20
        12-18

        1
        5
        8
        11
        17
        32
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 3)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 14)
    }

    @Suite(.tags(.live), .serialized)
    struct Day5Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 5 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 607)
        }
        
        @Test("Day 5 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 342433357244012)
        }
    }
}
