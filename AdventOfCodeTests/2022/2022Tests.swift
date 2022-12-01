import Foundation
import AdventOfCode
import XCTest

final class AoC_2022_Tests: XCTestCase {
    func test_day1_intro() throws {
        let problem = AoC_2022_Day1(.string("""
        1000
        2000
        3000

        4000

        5000
        6000

        7000
        8000
        9000

        10000
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 24000)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 45000)
    }

    func test_day1() throws {
        let problem = try AoC_2022_Day1(.url(Resources.url(for: "2022_day1")))

        var answer = 68802
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day1 / Part1 solution: \(answer)")

        answer = 205370
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day1 / Part2 solution: \(answer)")
    }
}
