import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day3
extension CurrentPuzzle: Puzzle {}

private struct Day3 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
        """)
        #expect(problem.solvePart1() == 161)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
        """)
        #expect(problem.solvePart2() == 48)
    }

    @Suite(.tags(.live), .serialized)
    struct Day3Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 3 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 170_778_545)
        }

        @Test("Day 3 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 82_868_252)
        }
    }
}
