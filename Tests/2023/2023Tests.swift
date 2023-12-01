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
}
