import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day19
extension CurrentPuzzle: Puzzle {}

private struct Day19 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        r, wr, b, g, bwu, rb, gb, br
        
        brwrr
        bggr
        gbbr
        rrbgbr
        ubwu
        bwurrg
        brgr
        bbrgwb
        """)
        #expect(problem.solvePart1() == 6)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        r, wr, b, g, bwu, rb, gb, br
        
        brwrr
        bggr
        gbbr
        rrbgbr
        ubwu
        bwurrg
        brgr
        bbrgwb
        """)
        #expect(problem.solvePart2() == 16)
    }

    @Suite(.tags(.live), .serialized)
    struct Day19Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 19 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 276)
        }
        
        @Test("Day 19 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 681_226_908_011_510)
        }
    }
}
