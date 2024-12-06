import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day6
extension CurrentPuzzle: Puzzle {}

private struct Day6 {
    @Test
    func part1_intro() async throws {
        let problem = try CurrentPuzzle("""
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """)
        try await #expect(problem.solvePart1() == 41)
    }

    @Test
    func part2_intro() async throws {
        let problem = try CurrentPuzzle("""
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """)
        try await #expect(problem.solvePart2() == 6)
    }

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try await #expect(problem.solvePart1() == 5_208)
        try await #expect(problem.solvePart2() == 1_972)
    }
}
