@testable import AoC_2023
import Testing

struct Day1 {
    @Test
    func part1_intro() async throws {
        let problem = AoC_2023_Day1("""
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """)
        #expect(try await problem.solvePart1() == 142)
    }

    @Test
    func part2_intro() async throws {
        let problem = AoC_2023_Day1("""
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
        let problem = try AoC_2023_Day1(file("2023_day1"))
        #expect(try await problem.solvePart1() == 54450)
        #expect(try await problem.solvePart2() == 54265)
    }
}
