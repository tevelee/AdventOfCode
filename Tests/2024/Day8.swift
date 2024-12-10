import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day8
extension CurrentPuzzle: Puzzle {}

private struct Day8 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        ......#....#
        ...#....0...
        ....#0....#.
        ..#....0....
        ....0....#..
        .#....A.....
        ...#........
        #......#....
        ........A...
        .........A..
        ..........#.
        ..........#.
        """)
        try #expect(problem.solvePart1() == 14)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        T....#....
        ...T......
        .T....#...
        .........#
        ..#.......
        ..........
        ...#......
        ..........
        ....#.....
        ..........
        """)
        try #expect(problem.solvePart2() == 9)
    }

    @Test
    func part2_intro2() throws {
        let problem = try CurrentPuzzle("""
        ......#....#
        ...#....0...
        ....#0....#.
        ..#....0....
        ....0....#..
        .#....A.....
        ...#........
        #......#....
        ........A...
        .........A..
        ..........#.
        ..........#.
        """)
        try #expect(problem.solvePart2() == 34)
    }

    @Suite(.tags(.live), .serialized)
    struct Day8Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 8 Part 1")
        func part1() throws {
            try #expect(problem.solvePart1() == 228)
        }

        @Test("Day 8 Part 2")
        func part2() throws {
            try #expect(problem.solvePart2() == 766)
        }
    }
}
