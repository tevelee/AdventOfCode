import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day9
extension CurrentPuzzle: Puzzle {}

private struct Day9 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("2333133121414131402")
        #expect(problem.solvePart1() == 1_928)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("2333133121414131402")
        #expect(problem.solvePart2() == 2_858)
    }

    @Test(.bug("https://www.reddit.com/r/adventofcode/comments/1hahd9s/comment/m18n5vw/"))
    func part2_reddit() throws {
        let problem = try CurrentPuzzle("23331331214141314022113")
        #expect(problem.solvePart2() == 3_317)
    }

    @Suite(.tags(.live), .serialized)
    struct Day9Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 9 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 6_154_342_787_400)
        }

        @Test("Day 9 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 6_183_632_723_350)
        }
    }
}
