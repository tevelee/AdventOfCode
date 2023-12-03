@testable import AoC_2023
import XCTest

final class AoC_2023_Tests: XCTestCase {
    private func file(_ fileName: String, fileExtension: String = "txt") throws -> Input {
        try .url(XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension)))
    }

    func test_day1_part1_intro() async throws {
        let problem = AoC_2023_Day1("""
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 142)
    }

    func test_day1_part2_intro() async throws {
        let problem = AoC_2023_Day1("""
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
        """)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 281)
    }

    func test_day1() async throws {
        let problem = try AoC_2023_Day1(file("2023_day1"))

        var answer = 54450
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day1 / Part1 solution: \(answer)")

        answer = 54265
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day1 / Part2 solution: \(answer)")
    }

    func test_day2_intro() throws {
        let problem = try AoC_2023_Day2("""
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        """)
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 8)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 2286)
    }

    func test_day2() throws {
        let problem = try AoC_2023_Day2(file("2023_day2"))

        var answer = 2551
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day2 / Part1 solution: \(answer)")

        answer = 62811
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day2 / Part2 solution: \(answer)")
    }

    func test_day3_intro() throws {
        let problem = try AoC_2023_Day3("""
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """)
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 4361)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 467835)
    }

    func test_day3() throws {
        let problem = try AoC_2023_Day3(file("2023_day3"))

        var answer = 507214
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day3 / Part1 solution: \(answer)")

        answer = 72553319
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day3 / Part2 solution: \(answer)")
    }
}
