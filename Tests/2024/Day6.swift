import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day6
extension CurrentPuzzle: Puzzle {}

private struct Day6 {
    @Test
    func part1_intro() throws {
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
        #expect(problem.solvePart1() == 41)
    }

    @Test
    func part2_intro() throws {
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
        #expect(problem.solvePart2() == 6)
    }

    @Suite(.tags(.live), .serialized)
    struct Day6Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 6 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 5_208)
        }

        @Test("Day 6 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 1_972)
        }
    }
}
