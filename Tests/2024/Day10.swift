import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day10
extension CurrentPuzzle: Puzzle {}

private struct Day10 {
    @Test
    func part1_intro1() throws {
        let problem = try CurrentPuzzle("""
        0123
        1234
        8765
        9876
        """)
        try #expect(problem.solvePart1() == 1)
    }

    @Test
    func part1_intro2() throws {
        let problem = try CurrentPuzzle("""
        ...0...
        ...1...
        ...2...
        6543456
        7.....7
        8.....8
        9.....9
        """)
        try #expect(problem.solvePart1() == 2)
    }

    @Test
    func part1_intro3() throws {
        let problem = try CurrentPuzzle("""
        ..90..9
        ...1.98
        ...2..7
        6543456
        765.987
        876....
        987....
        """)
        try #expect(problem.solvePart1() == 4)
    }

    @Test
    func part1_intro4() throws {
        let problem = try CurrentPuzzle("""
        10..9..
        2...8..
        3...7..
        4567654
        ...8..3
        ...9..2
        .....01
        """)
        try #expect(problem.solvePart1() == 3)
    }

    @Test
    func part1_intro5() throws {
        let problem = try CurrentPuzzle("""
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """)
        try #expect(problem.solvePart1() == 36)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """)
        try #expect(problem.solvePart2() == 81)
    }

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        try #expect(problem.solvePart1() == 717)
        try #expect(problem.solvePart2() == 1_686)
    }
}
