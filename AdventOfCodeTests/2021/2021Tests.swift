import Foundation
import AdventOfCode
import XCTest

final class AoC_2021_Tests: XCTestCase {
    func test_day1() async throws {
        let problem = try AoC_2021_Day1(Resources.url(for: "2021_day1"))

        var answer = 1448
        var result = try await problem.solvePart1_imperative()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart1_functional()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart1_lazy()
        XCTAssertEqual(result, answer)
        print("Day1 / Part1 solution: \(answer)")

        answer = 1471
        result = try await problem.solvePart2_imperative()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart2_functional()
        XCTAssertEqual(result, answer)
        result = try await problem.solvePart2_lazy()
        XCTAssertEqual(result, answer)
        print("Day1 / Part2 solution: \(answer)")
    }

    func test_day2() async throws {
        let problem = try AoC_2021_Day2(Resources.url(for: "2021_day2"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 2187380)
        print("Day2 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 2086357770)
        print("Day2 / Part2 solution: \(part2)")
    }

    func test_day3() async throws {
        let problem = try AoC_2021_Day3(Resources.url(for: "2021_day3"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 0)
        print("Day3 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 0)
        print("Day3 / Part2 solution: \(part2)")
    }
}
