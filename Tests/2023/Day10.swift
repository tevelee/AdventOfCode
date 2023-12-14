@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day10
extension CurrentPuzzle: Puzzle {}

private struct Day10 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle("""
        -L|F7
        7S-7|
        L|7||
        -L-J|
        L|-JF
        """)
        #expect(problem.solvePart1() == 4)
        #expect(problem.solvePart2() == 1)
    }

    @Test
    func intro2() throws {
        let problem = try CurrentPuzzle("""
        ..F7.
        .FJ|.
        SJ.L7
        |F--J
        LJ...
        """)
        #expect(problem.solvePart1() == 8)
        #expect(problem.solvePart2() == 1)
    }

        struct Part2 {
        @Test
        func intro1() throws {
            let problem = try CurrentPuzzle("""
            ...........
            .S-------7.
            .|F-----7|.
            .||.....||.
            .||.....||.
            .|L-7.F-J|.
            .|..|.|..|.
            .L--J.L--J.
            ...........
            """)
            #expect(problem.solvePart2() == 4)
        }

        @Test
        func intro2() throws {
            let problem = try CurrentPuzzle("""
            ..........
            .S------7.
            .|F----7|.
            .||OOOO||.
            .||OOOO||.
            .|L-7F-J|.
            .|II||II|.
            .L--JL--J.
            ..........
            """)
            #expect(problem.solvePart2() == 4)
        }

        @Test
        func intro3() throws {
            let problem = try CurrentPuzzle("""
            .F----7F7F7F7F-7....
            .|F--7||||||||FJ....
            .||.FJ||||||||L7....
            FJL7L7LJLJ||LJ.L-7..
            L--J.L7...LJS7F-7L7.
            ....F-J..F7FJ|L7L7L7
            ....L7.F7||L7|.L7L7|
            .....|FJLJ|FJ|F7|.LJ
            ....FJL-7.||.||||...
            ....L---J.LJ.LJLJ...
            """)
            #expect(problem.solvePart2() == 8)
        }

        @Test
        func intro4() throws {
            let problem = try CurrentPuzzle("""
            FF7FSF7F7F7F7F7F---7
            L|LJ||||||||||||F--J
            FL-7LJLJ||||||LJL-77
            F--JF--7||LJLJ7F7FJ-
            L---JF-JLJ.||-FJLJJ7
            |F|F-JF---7F7-L7L|7|
            |FFJF7L7F-JF7|JL---7
            7-L-JL7||F7|L7F-7F7|
            L.L7LFJ|||||FJL7||LJ
            L7JLJL-JLJLJL--JLJ.L
            """)
            #expect(problem.solvePart2() == 10)
        }
    }
    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 7066)
        #expect(problem.solvePart2() == 401)
    }
}
