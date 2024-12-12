import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day12
extension CurrentPuzzle: Puzzle {}

private struct Day12 {
    @Test
    func part1_intro1() throws {
        let problem = try CurrentPuzzle("""
        AAAA
        BBCD
        BBCC
        EEEC
        """)
        #expect(problem.solvePart1() == 140)
    }

    @Test
    func part1_intro2() throws {
        let problem = try CurrentPuzzle("""
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """)
        #expect(problem.solvePart1() == 772)
    }

    @Test
    func part1_intro3() throws {
        let problem = try CurrentPuzzle("""
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
        """)
        #expect(problem.solvePart1() == 1_930)
    }

    @Test
    func part2_intro1() throws {
        let problem = try CurrentPuzzle("""
        AAAA
        BBCD
        BBCC
        EEEC
        """)
        #expect(problem.solvePart2() == 80)
    }

    @Test
    func part2_intro2() throws {
        let problem = try CurrentPuzzle("""
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """)
        #expect(problem.solvePart2() == 436)
    }

    @Test
    func part2_intro3() throws {
        let problem = try CurrentPuzzle("""
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE
        """)
        #expect(problem.solvePart2() == 236)
    }

    @Test
    func part2_intro4() throws {
        let problem = try CurrentPuzzle("""
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA
        """)
        #expect(problem.solvePart2() == 368)
    }

    @Test
    func part2_intro5() throws {
        let problem = try CurrentPuzzle("""
        RRRRIICCFF
        RRRRIICCCF
        VVRRRCCFFF
        VVRCCCJFFF
        VVVVCJJCFE
        VVIVCCJJEE
        VVIIICJJEE
        MIIIIIJJEE
        MIIISIJEEE
        MMMISSJEEE
        """)
        #expect(problem.solvePart2() == 1_206)
    }


    @Suite(.tags(.live), .serialized)
    struct Day12Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 12 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 1_549_354)
        }
        
        @Test("Day 12 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 937_032)
        }
    }
}
