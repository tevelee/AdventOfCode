@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day1
extension CurrentPuzzle: Puzzle {}

private struct Day1 {
    @Test
    func part1_intro() async throws {
        let problem = CurrentPuzzle("""
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """)
        #expect(try await problem.solvePart1() == 142)
    }

    @Test
    func part2_intro() async throws {
        let problem = CurrentPuzzle("""
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """)
        #expect(try await problem.solvePart2() == 281)
    }

    @Test(.tags(.green))
    func live() async throws {
        let problem = try CurrentPuzzle()
        #expect(try await problem.solvePart1() == 54_450)
        #expect(try await problem.solvePart2() == 54_265)
    }
}
