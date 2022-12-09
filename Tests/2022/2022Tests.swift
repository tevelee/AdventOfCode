import AoC_2022
import XCTest

final class AoC_2022_Tests: XCTestCase {
    func url(for fileName: String, fileExtension: String = "txt") throws -> URL {
        try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
    }

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
        let problem = try AoC_2022_Day1(.url(url(for: "2022_day1")))

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
        let problem = try AoC_2022_Day2(.url(url(for: "2022_day2")))

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
        let problem = try AoC_2022_Day3(.url(url(for: "2022_day3")))

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
        let problem = try AoC_2022_Day4(.url(url(for: "2022_day4")))

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
        let problem = try AoC_2022_Day5(.url(url(for: "2022_day5")))

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
        let problem = try AoC_2022_Day6(.url(url(for: "2022_day6")))

        var answer = 1920
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day6 / Part1 solution: \(answer)")

        answer = 2334
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day6 / Part2 solution: \(answer)")
    }

    func test_day7_intro() throws {
        let problem = AoC_2022_Day7(.string("""
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 95437)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 24933642)
    }

    func test_day7() throws {
        let problem = try AoC_2022_Day7(.url(url(for: "2022_day7")))

        var answer = 1334506
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day7 / Part1 solution: \(answer)")

        answer = 7421137
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day7 / Part2 solution: \(answer)")
    }

    func test_day8_intro() throws {
        let problem = AoC_2022_Day8(.string("""
        30373
        25512
        65332
        33549
        35390
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 21)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 8)
    }

    func test_day8() throws {
        let problem = try AoC_2022_Day8(.url(url(for: "2022_day8")))

        var answer = 1796
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day8 / Part1 solution: \(answer)")

        answer = 288120
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day8 / Part2 solution: \(answer)")
    }

    func test_day9_intro() async throws {
        let problem = AoC_2022_Day9(.string("""
        R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 13)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 1)
    }

    func test_day9_intro2() async throws {
        let problem = AoC_2022_Day9(.string("""
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 88)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 36)
    }

    func test_day9() async throws {
        let problem = try AoC_2022_Day9(.url(url(for: "2022_day9")))

        var answer = 5960
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day9 / Part1 solution: \(answer)")

        answer = 2327
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day9 / Part2 solution: \(answer)")
    }
}
