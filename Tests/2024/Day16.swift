import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day16
extension CurrentPuzzle: Puzzle {}

private struct Day16 {
    @Test
    func part1_small() throws {
        let problem = try CurrentPuzzle("""
        ###############
        #.......#....E#
        #.#.###.#.###.#
        #.....#.#...#.#
        #.###.#####.#.#
        #.#.#.......#.#
        #.#.#####.###.#
        #...........#.#
        ###.#.#####.#.#
        #...#.....#.#.#
        #.#.#.###.#.#.#
        #.....#...#.#.#
        #.###.#.#.#.#.#
        #S..#.....#...#
        ###############
        """)
        #expect(problem.solvePart1() == 7_036)
    }

    @Test
    func part1_large() throws {
        let problem = try CurrentPuzzle("""
        #################
        #...#...#...#..E#
        #.#.#.#.#.#.#.#.#
        #.#.#.#...#...#.#
        #.#.#.#.###.#.#.#
        #...#.#.#.....#.#
        #.#.#.#.#.#####.#
        #.#...#.#.#.....#
        #.#.#####.#.###.#
        #.#.#.......#...#
        #.#.###.#####.###
        #.#.#...#.....#.#
        #.#.#.#####.###.#
        #.#.#.........#.#
        #.#.#.#########.#
        #S#.............#
        #################
        """)
        #expect(problem.solvePart1() == 11_048)
    }

    @Test
    func part2_small() throws {
        let problem = try CurrentPuzzle("""
        ###############
        #.......#....E#
        #.#.###.#.###.#
        #.....#.#...#.#
        #.###.#####.#.#
        #.#.#.......#.#
        #.#.#####.###.#
        #...........#.#
        ###.#.#####.#.#
        #...#.....#.#.#
        #.#.#.###.#.#.#
        #.....#...#.#.#
        #.###.#.#.#.#.#
        #S..#.....#...#
        ###############
        """)
        #expect(problem.solvePart2() == 45)
    }

    @Test
    func part2_large() throws {
        let problem = try CurrentPuzzle("""
        #################
        #...#...#...#..E#
        #.#.#.#.#.#.#.#.#
        #.#.#.#...#...#.#
        #.#.#.#.###.#.#.#
        #...#.#.#.....#.#
        #.#.#.#.#.#####.#
        #.#...#.#.#.....#
        #.#.#####.#.###.#
        #.#.#.......#...#
        #.#.###.#####.###
        #.#.#...#.....#.#
        #.#.#.#####.###.#
        #.#.#.........#.#
        #.#.#.#########.#
        #S#.............#
        #################
        """)
        #expect(problem.solvePart2() == 64)
    }

    @Suite(.tags(.live), .serialized)
    struct Day16Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 16 Part 1")
        func part1() throws {
            #expect(problem.solvePart1() == 123_540)
        }
        
        @Test("Day 16 Part 2")
        func part2() throws {
            #expect(problem.solvePart2() == 665)
        }
    }
}
