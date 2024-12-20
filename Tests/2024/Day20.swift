import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day20
extension CurrentPuzzle: Puzzle {}

private struct Day20 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        ###############
        #...#...#.....#
        #.#.#.#.#.###.#
        #S#...#.#.#...#
        #######.#.#.###
        #######.#.#...#
        #######.#.###.#
        ###..E#...#...#
        ###.#######.###
        #...###...#...#
        #.#####.#.###.#
        #.#...#.#.#...#
        #.#.#.#.#.#.###
        #...#...#...###
        ###############
        """)
        #expect(problem.solve(max: 2, saves: 2) == 14)
        #expect(problem.solve(max: 2, saves: 4) == 14)
        #expect(problem.solve(max: 2, saves: 6) == 2)
        #expect(problem.solve(max: 2, saves: 8) == 4)
        #expect(problem.solve(max: 2, saves: 10) == 2)
        #expect(problem.solve(max: 2, saves: 12) == 3)
        #expect(problem.solve(max: 2, saves: 20) == 1)
        #expect(problem.solve(max: 2, saves: 36) == 1)
        #expect(problem.solve(max: 2, saves: 38) == 1)
        #expect(problem.solve(max: 2, saves: 40) == 1)
        #expect(problem.solve(max: 2, saves: 64) == 1)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        ###############
        #...#...#.....#
        #.#.#.#.#.###.#
        #S#...#.#.#...#
        #######.#.#.###
        #######.#.#...#
        #######.#.###.#
        ###..E#...#...#
        ###.#######.###
        #...###...#...#
        #.#####.#.###.#
        #.#...#.#.#...#
        #.#.#.#.#.#.###
        #...#...#...###
        ###############
        """)
        #expect(problem.solve(max: 20, saves: 50) == 32)
        #expect(problem.solve(max: 20, saves: 52) == 31)
        #expect(problem.solve(max: 20, saves: 54) == 29)
        #expect(problem.solve(max: 20, saves: 56) == 39)
        #expect(problem.solve(max: 20, saves: 58) == 25)
        #expect(problem.solve(max: 20, saves: 60) == 23)
        #expect(problem.solve(max: 20, saves: 62) == 20)
        #expect(problem.solve(max: 20, saves: 64) == 19)
        #expect(problem.solve(max: 20, saves: 66) == 12)
        #expect(problem.solve(max: 20, saves: 68) == 14)
        #expect(problem.solve(max: 20, saves: 70) == 12)
        #expect(problem.solve(max: 20, saves: 72) == 22)
        #expect(problem.solve(max: 20, saves: 74) == 4)
        #expect(problem.solve(max: 20, saves: 76) == 3)
    }

    @Suite(.tags(.live), .serialized, .disabled("runs too long"))
    struct Day20Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 20 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 1_429)
        }

        @Test("Day 20 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 988_931)
        }
    }
}
