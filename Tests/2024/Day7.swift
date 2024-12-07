import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day7
extension CurrentPuzzle: Puzzle {}

private struct Day7 {
    @Test
    func part1_intro() async throws {
        let problem = try CurrentPuzzle("""
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
        """)
        #expect(problem.solvePart1() == 3_749)
    }

    @Test
    func part2_intro() async throws {
        let problem = try CurrentPuzzle("""
        190: 10 19
        3267: 81 40 27
        83: 17 5
        156: 15 6
        7290: 6 8 6 15
        161011: 16 10 13
        192: 17 8 14
        21037: 9 7 18 13
        292: 11 6 16 20
        """)
        #expect(problem.solvePart2() == 11_387)
    }

    @Test(.tags(.live))
    func live() async throws {
        let problem = try await CurrentPuzzle()
        #expect(problem.solvePart1() == 5_512_534_574_980)
        #expect(problem.solvePart2() == 328_790_210_468_594)
    }
}
