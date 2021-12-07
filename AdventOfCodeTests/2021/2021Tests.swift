import Foundation
import AdventOfCode
import XCTest

final class AoC_2021_Tests: XCTestCase {
    func test_day1_intro() async throws {
        let problem = AoC_2021_Day1("""
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
        """)
        let part1 = try await problem.solvePart1_functional()
        XCTAssertEqual(part1, 7)
        let part2 = try await problem.solvePart2_functional()
        XCTAssertEqual(part2, 5)
    }

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

    func test_day2_intro() async throws {
        let problem = AoC_2021_Day2("""
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 150)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 900)
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

    func test_day3_intro() async throws {
        let problem = AoC_2021_Day3("""
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 198)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 230)
    }

    func test_day3() async throws {
        let problem = try AoC_2021_Day3(Resources.url(for: "2021_day3"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 3277364)
        print("Day3 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 5736383)
        print("Day3 / Part2 solution: \(part2)")
    }

    func test_day4_intro() async throws {
        let problem = AoC_2021_Day4("""
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11 0
        8 2 23 4 24
        21 9 14 16 7
        6 10 3 18 5
        1 12 20 15 19

        3 15 0 2 22
        9 18 13 17 5
        19 8 7 25 23
        20 11 10 24 4
        14 21 16 12 6

        14 21 17 24 4
        10 16 15 9 19
        18 8 23 26 20
        22 11 13 6 5
        2 0 12 3 7
        """)
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 4512)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 1924)
    }

    func test_day4() throws {
        let problem = try AoC_2021_Day4(Resources.url(for: "2021_day4"))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 11536)
        print("Day4 / Part1 solution: \(part1)")
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 1284)
        print("Day4 / Part2 solution: \(part2)")
    }

    func test_day5_intro() async throws {
        let problem = AoC_2021_Day5("""
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
        """)
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 5)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 12)
    }

    func test_day5() async throws {
        let problem = try AoC_2021_Day5(Resources.url(for: "2021_day5"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 7380)
        print("Day5 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 21373)
        print("Day5 / Part2 solution: \(part2)")
    }

    func test_day6_intro() {
        let problem = AoC_2021_Day6("3,4,3,1,2")
        XCTAssertEqual(problem.solvePart1(), 5934)
        XCTAssertEqual(problem.solvePart2(), 26984457539)
    }

    func test_day6() throws {
        let problem = try AoC_2021_Day6(Resources.url(for: "2021_day6"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 352195)
        print("Day6 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 1600306001288)
        print("Day6 / Part2 solution: \(part2)")
    }

    func test_day7_intro() {
        let problem = AoC_2021_Day7("16,1,2,0,4,2,7,1,2,14")
        XCTAssertEqual(problem.solvePart1(), 37)
        XCTAssertEqual(problem.solvePart2(), 168)
    }

    func test_day7() throws {
        let problem = try AoC_2021_Day7(Resources.url(for: "2021_day7"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 336131)
        print("Day7 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 92676646)
        print("Day7 / Part2 solution: \(part2)")
    }
}
