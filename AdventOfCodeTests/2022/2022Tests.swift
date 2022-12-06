import Foundation
import AdventOfCode
import XCTest

@available(macOS 13.0, iOS 14.0, *)
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

    func test_day2_intro() async throws {
        let problem = AoC_2022_Day2(.string("""
        A Y
        B X
        C Z
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 15)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 12)
    }

    func test_day2() async throws {
        let problem = try AoC_2022_Day2(.url(Resources.url(for: "2022_day2")))

        var answer = 11873
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day2 / Part1 solution: \(answer)")

        answer = 12014
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day2 / Part2 solution: \(answer)")
    }

    func test_day3_intro() async throws {
        let problem = AoC_2022_Day3(.string("""
        vJrwpWtwJgWrhcsFMMfFFhFp
        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        PmmdzqPrVvPwwTWBwg
        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        ttgJtRGJQctTZtZT
        CrZsJsPPZsGzwwsLwLmpwMDw
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 157)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 70)
    }

    func test_day3() async throws {
        let problem = try AoC_2022_Day3(.url(Resources.url(for: "2022_day3")))

        var answer = 7763
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day3 / Part1 solution: \(answer)")

        answer = 2569
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day3 / Part2 solution: \(answer)")
    }

    func test_day4_intro() async throws {
        let problem = AoC_2022_Day4(.string("""
        2-4,6-8
        2-3,4-5
        5-7,7-9
        2-8,3-7
        6-6,4-6
        2-6,4-8
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 2)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 4)
    }

    func test_day4() async throws {
        let problem = try AoC_2022_Day4(.url(Resources.url(for: "2022_day4")))

        var answer = 534
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day4 / Part1 solution: \(answer)")

        answer = 841
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day4 / Part2 solution: \(answer)")
    }

    func test_day5_intro() throws {
        let problem = AoC_2022_Day5(.string("""
            [D]
        [N] [C]
        [Z] [M] [P]
         1   2   3

        move 1 from 2 to 1
        move 3 from 1 to 3
        move 2 from 2 to 1
        move 1 from 1 to 2
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, "CMZ")
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, "MCD")
    }

    func test_day5() throws {
        let problem = try AoC_2022_Day5(.url(Resources.url(for: "2022_day5")))

        var answer = "WHTLRMZRC"
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day5 / Part1 solution: \(answer)")

        answer = "GMPMLWNMG"
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day5 / Part2 solution: \(answer)")
    }

    func test_day6_intro() throws {
        try XCTAssertEqual(AoC_2022_Day6(.string("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).solvePart1(), 7)
        try XCTAssertEqual(AoC_2022_Day6(.string("bvwbjplbgvbhsrlpgdmjqwftvncz")).solvePart1(), 5)
        try XCTAssertEqual(AoC_2022_Day6(.string("nppdvjthqldpwncqszvftbrmjlhg")).solvePart1(), 6)
        try XCTAssertEqual(AoC_2022_Day6(.string("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")).solvePart1(), 10)
        try XCTAssertEqual(AoC_2022_Day6(.string("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")).solvePart1(), 11)

        try XCTAssertEqual(AoC_2022_Day6(.string("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).solvePart2(), 19)
        try XCTAssertEqual(AoC_2022_Day6(.string("bvwbjplbgvbhsrlpgdmjqwftvncz")).solvePart2(), 23)
        try XCTAssertEqual(AoC_2022_Day6(.string("nppdvjthqldpwncqszvftbrmjlhg")).solvePart2(), 23)
        try XCTAssertEqual(AoC_2022_Day6(.string("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")).solvePart2(), 29)
        try XCTAssertEqual(AoC_2022_Day6(.string("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")).solvePart2(), 26)
    }

    func test_day6() throws {
        let problem = try AoC_2022_Day6(.url(Resources.url(for: "2022_day6")))

        var answer = 1920
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day6 / Part1 solution: \(answer)")

        answer = 2334
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day6 / Part2 solution: \(answer)")
    }
}
