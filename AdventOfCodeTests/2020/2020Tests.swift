import Foundation
import AdventOfCode
import XCTest

final class AoC_2020_Tests: XCTestCase {
    func test_day1() async throws {
        let problem = try AoC_2020_Day1(Resources.url(for: "2020_day1"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 1007331)
        print("Day1 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 48914340)
        print("Day1 / Part2 solution: \(part2)")
    }

    func test_day2() async throws {
        let problem = try AoC_2020_Day2(Resources.url(for: "2020_day2"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 445)
        print("Day2 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 491)
        print("Day2 / Part2 solution: \(part2)")
    }

    func test_day3() async throws {
        let problem = try AoC_2020_Day3(Resources.url(for: "2020_day3"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 299)
        print("Day3 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3621285278)
        print("Day3 / Part2 solution: \(part2)")
    }

    func test_day4() async throws {
        let problem = try AoC_2020_Day4(Resources.url(for: "2020_day4"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 219)
        print("Day4 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 127)
        print("Day4 / Part2 solution: \(part2)")
    }

    func test_day5() async throws {
        let problem = try AoC_2020_Day5(Resources.url(for: "2020_day5"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 880)
        print("Day5 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 731)
        print("Day5 / Part2 solution: \(part2)")
    }

    func test_day6() async throws {
        let problem = try AoC_2020_Day6(Resources.url(for: "2020_day6"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 6782)
        print("Day6 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3596)
        print("Day6 / Part2 solution: \(part2)")
    }
}
