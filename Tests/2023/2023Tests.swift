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

        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 54450)
        print("Day1 / Part1 solution: \(part1)")

        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 54265)
        print("Day1 / Part2 solution: \(part2)")
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

        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 2551)
        print("Day2 / Part1 solution: \(part1)")

        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 62811)
        print("Day2 / Part2 solution: \(part2)")
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

        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 507214)
        print("Day3 / Part1 solution: \(part1)")

        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 72553319)
        print("Day3 / Part2 solution: \(part2)")
    }

    func test_day4_intro() throws {
        let problem = try AoC_2023_Day4("""
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        """)
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 13)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 30)
    }

    func test_day4() throws {
        let problem = try AoC_2023_Day4(file("2023_day4"))

        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 27059)
        print("Day4 / Part1 solution: \(part1)")

        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 5744979)
        print("Day4 / Part2 solution: \(part2)")
    }

    func test_day5_intro() throws {
        let problem = try AoC_2023_Day5("""
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
        """)
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 35)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 46)
    }

    func test_day5() throws {
        let problem = try AoC_2023_Day5(file("2023_day5"))

        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 251346198)
        print("Day5 / Part1 solution: \(part1)")

        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 72263011)
        print("Day5 / Part2 solution: \(part2)")
    }

    func test_day6_intro() throws {
        let problem = AoC_2023_Day6("""
        Time:      7  15   30
        Distance:  9  40  200
        """)
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 288)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 71503)
    }

    func test_day6() throws {
        let problem = try AoC_2023_Day6(file("2023_day6"))

        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 138915)
        print("Day6 / Part1 solution: \(part1)")

        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 27340847)
        print("Day6 / Part2 solution: \(part2)")
    }

//    func test_dayX_intro() {
//        let problem = AoC_2023_DayX("""
//        """)
//        let part1 = problem.solvePart1()
//        XCTAssertEqual(part1, 0)
//        let part2 = problem.solvePart2()
//        XCTAssertEqual(part2, 0)
//    }
//
//    func test_dayX() throws {
//        let problem = try AoC_2023_DayX(file("2023_dayX"))
//
//        let part1 = problem.solvePart1()
//        XCTAssertEqual(part1, 0)
//        print("DayX / Part1 solution: \(part1)")
//
//        let part2 = problem.solvePart2()
//        XCTAssertEqual(part2, 0)
//        print("DayX / Part2 solution: \(part2)")
//    }
}
