import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day4
extension CurrentPuzzle: Puzzle {}

private struct Day4 {
    @Test
    func part1_intro() async throws {
        let problem = try CurrentPuzzle("""
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """)
        try await #expect(problem.solvePart1() == 18)
    }

    @Test
    func part2_intro() async throws {
        let problem = try CurrentPuzzle("""
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """)
        try await #expect(problem.solvePart2() == 9)
    }

    @Suite(.tags(.live), .serialized)
    struct Day4Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 4 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 2_464)
        }

        @Test("Day 4 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 1_982)
        }
    }
}
