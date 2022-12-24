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

    func test_day10_intro() async throws {
        let problem = AoC_2022_Day10(.string("""
        addx 15
        addx -11
        addx 6
        addx -3
        addx 5
        addx -1
        addx -8
        addx 13
        addx 4
        noop
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx 5
        addx -1
        addx -35
        addx 1
        addx 24
        addx -19
        addx 1
        addx 16
        addx -11
        noop
        noop
        addx 21
        addx -15
        noop
        noop
        addx -3
        addx 9
        addx 1
        addx -3
        addx 8
        addx 1
        addx 5
        noop
        noop
        noop
        noop
        noop
        addx -36
        noop
        addx 1
        addx 7
        noop
        noop
        noop
        addx 2
        addx 6
        noop
        noop
        noop
        noop
        noop
        addx 1
        noop
        noop
        addx 7
        addx 1
        noop
        addx -13
        addx 13
        addx 7
        noop
        addx 1
        addx -33
        noop
        noop
        noop
        addx 2
        noop
        noop
        noop
        addx 8
        noop
        addx -1
        addx 2
        addx 1
        noop
        addx 17
        addx -9
        addx 1
        addx 1
        addx -3
        addx 11
        noop
        noop
        addx 1
        noop
        addx 1
        noop
        noop
        addx -13
        addx -19
        addx 1
        addx 3
        addx 26
        addx -30
        addx 12
        addx -1
        addx 3
        addx 1
        noop
        noop
        noop
        addx -9
        addx 18
        addx 1
        addx 2
        noop
        noop
        addx 9
        noop
        noop
        noop
        addx -1
        addx 2
        addx -37
        addx 1
        addx 3
        noop
        addx 15
        addx -21
        addx 22
        addx -6
        addx 1
        noop
        addx 2
        addx 1
        noop
        addx -10
        noop
        noop
        addx 20
        addx 1
        addx 2
        addx 2
        addx -6
        addx -11
        noop
        noop
        noop
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 13140)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, "????????")
    }

    func test_day10() async throws {
        let problem = try AoC_2022_Day10(.url(url(for: "2022_day10")))

        let answerToPart1 = 16060
        let resultOfPart1 = try await problem.solvePart1()
        XCTAssertEqual(resultOfPart1, answerToPart1)
        print("Day10 / Part1 solution: \(answerToPart1)")

        let answerToPart2 = "BACEKLHF"
        let resultOfPart2 = try await problem.solvePart2()
        XCTAssertEqual(resultOfPart2, answerToPart2)
        print("Day10 / Part2 solution: \(answerToPart2)")
    }

    func test_day11_intro() throws {
        let problem = AoC_2022_Day11(.string("""
        Monkey 0:
          Starting items: 79, 98
          Operation: new = old * 19
          Test: divisible by 23
            If true: throw to monkey 2
            If false: throw to monkey 3

        Monkey 1:
          Starting items: 54, 65, 75, 74
          Operation: new = old + 6
          Test: divisible by 19
            If true: throw to monkey 2
            If false: throw to monkey 0

        Monkey 2:
          Starting items: 79, 60, 97
          Operation: new = old * old
          Test: divisible by 13
            If true: throw to monkey 1
            If false: throw to monkey 3

        Monkey 3:
          Starting items: 74
          Operation: new = old + 3
          Test: divisible by 17
            If true: throw to monkey 0
            If false: throw to monkey 1
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 10605)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 2713310158)
    }

    func test_day11() throws {
        let problem = try AoC_2022_Day11(.url(url(for: "2022_day11")))

        var answer = 50830
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day11 / Part1 solution: \(answer)")

        answer = 14399640002
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day11 / Part2 solution: \(answer)")
    }

    func test_day12_intro() throws {
        let problem = try AoC_2022_Day12(.string("""
        Sabqponm
        abcryxxl
        accszExk
        acctuvwj
        abdefghi
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 31)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 29)
    }

    func test_day12() throws {
        let problem = try AoC_2022_Day12(.url(url(for: "2022_day12")))

        var answer = 462
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day12 / Part1 solution: \(answer)")

        answer = 451
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day12 / Part2 solution: \(answer)")
    }

    func test_day13_intro() async throws {
        let problem = AoC_2022_Day13(.string("""
        [1,1,3,1,1]
        [1,1,5,1,1]

        [[1],[2,3,4]]
        [[1],4]

        [9]
        [[8,7,6]]

        [[4,4],4,4]
        [[4,4],4,4,4]

        [7,7,7,7]
        [7,7,7]

        []
        [3]

        [[[]]]
        [[]]

        [1,[2,[3,[4,[5,6,7]]]],8,9]
        [1,[2,[3,[4,[5,6,0]]]],8,9]
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 13)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 140)
    }

    func test_day13() async throws {
        let problem = try AoC_2022_Day13(.url(url(for: "2022_day13")))

        var answer = 4643
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day13 / Part1 solution: \(answer)")

        answer = 21614
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day13 / Part2 solution: \(answer)")
    }

    func test_day14_intro() throws {
        let problem = try AoC_2022_Day14(.string("""
        498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9
        """))
        let part1 = try problem.solvePart1()
        XCTAssertEqual(part1, 24)
        let part2 = try problem.solvePart2()
        XCTAssertEqual(part2, 93)
    }

    func test_day14() throws {
        let problem = try AoC_2022_Day14(.url(url(for: "2022_day14")))

        var answer = 683
        var result = try problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day14 / Part1 solution: \(answer)")

        answer = 28821
        result = try problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day14 / Part2 solution: \(answer)")
    }

    func test_day15_intro() throws {
        let problem = try AoC_2022_Day15(.string("""
        Sensor at x=2, y=18: closest beacon is at x=-2, y=15
        Sensor at x=9, y=16: closest beacon is at x=10, y=16
        Sensor at x=13, y=2: closest beacon is at x=15, y=3
        Sensor at x=12, y=14: closest beacon is at x=10, y=16
        Sensor at x=10, y=20: closest beacon is at x=10, y=16
        Sensor at x=14, y=17: closest beacon is at x=10, y=16
        Sensor at x=8, y=7: closest beacon is at x=2, y=10
        Sensor at x=2, y=0: closest beacon is at x=2, y=10
        Sensor at x=0, y=11: closest beacon is at x=2, y=10
        Sensor at x=20, y=14: closest beacon is at x=25, y=17
        Sensor at x=17, y=20: closest beacon is at x=21, y=22
        Sensor at x=16, y=7: closest beacon is at x=15, y=3
        Sensor at x=14, y=3: closest beacon is at x=15, y=3
        Sensor at x=20, y=1: closest beacon is at x=15, y=3
        """))
        let part1 = try problem.solvePart1(y: 10)
        XCTAssertEqual(part1, 26)
        let part2 = try problem.solvePart2(range: 0...20)
        XCTAssertEqual(part2, 56000011)
    }

    func test_day15() throws {
        let problem = try AoC_2022_Day15(.url(url(for: "2022_day15")))

        var answer = 4861076
        var result = try problem.solvePart1(y: 2_000_000)
        XCTAssertEqual(result, answer)
        print("Day15 / Part1 solution: \(answer)")

        answer = 10649103160102
        result = try problem.solvePart2(range: 0...4_000_000)
        XCTAssertEqual(result, answer)
        print("Day15 / Part2 solution: \(answer)")
    }

    func test_day16_intro() throws {
        let problem = try AoC_2022_Day16(.string("""
        Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
        Valve BB has flow rate=13; tunnels lead to valves CC, AA
        Valve CC has flow rate=2; tunnels lead to valves DD, BB
        Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
        Valve EE has flow rate=3; tunnels lead to valves FF, DD
        Valve FF has flow rate=0; tunnels lead to valves EE, GG
        Valve GG has flow rate=0; tunnels lead to valves FF, HH
        Valve HH has flow rate=22; tunnel leads to valve GG
        Valve II has flow rate=0; tunnels lead to valves AA, JJ
        Valve JJ has flow rate=21; tunnel leads to valve II
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 1651)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 1707)
    }

    func test_day16() throws {
        let problem = try AoC_2022_Day16(.url(url(for: "2022_day16")))

        var answer = 1638
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day16 / Part1 solution: \(answer)")

        answer = 2400
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day16 / Part2 solution: \(answer)")
    }

    func test_day17_intro() throws {
        let problem = try AoC_2022_Day17(.string("""
        >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 3068)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 1_514_285_714_288)
    }

    func test_day17() throws {
        let problem = try AoC_2022_Day17(.url(url(for: "2022_day17")))

        var answer = 3083
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day17 / Part1 solution: \(answer)")

        answer = 1532183908048
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day17 / Part2 solution: \(answer)")
    }

    func test_day18_intro() async throws {
        let problem = try AoC_2022_Day18(.string("""
        2,2,2
        1,2,2
        3,2,2
        2,1,2
        2,3,2
        2,2,1
        2,2,3
        2,2,4
        2,2,6
        1,2,5
        3,2,5
        2,1,5
        2,3,5
        """))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 64)
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 58)
    }

    func test_day18() async throws {
        let problem = try AoC_2022_Day18(.url(url(for: "2022_day18")))

        var answer = 4460
        var result = try await problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day18 / Part1 solution: \(answer)")

        answer = 2498
        result = try await problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day18 / Part2 solution: \(answer)")
    }

    func test_day19_intro() async throws {
        let problem = try AoC_2022_Day19(.string("""
        Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
        Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 33)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 56 * 62)
    }

    func test_day19() async throws {
        let problem = try AoC_2022_Day19(.url(url(for: "2022_day19")))

        var answer = 1150
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day19 / Part1 solution: \(answer)")

        answer = 37367
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day19 / Part2 solution: \(answer)")
    }

    func test_day20_intro() throws {
        let problem = try AoC_2022_Day20(.string("""
        1
        2
        -3
        3
        -2
        0
        4
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 3)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 1623178306)
    }

    func test_day20() throws {
        let problem = try AoC_2022_Day20(.url(url(for: "2022_day20")))

        var answer = 13883
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day20 / Part1 solution: \(answer)")

        answer = 19185967576920
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day20 / Part2 solution: \(answer)")
    }

    func test_day21_intro() throws {
        let problem = try AoC_2022_Day21(.string("""
        root: pppw + sjmn
        dbpl: 5
        cczh: sllz + lgvd
        zczc: 2
        ptdq: humn - dvpt
        dvpt: 3
        lfqf: 4
        humn: 5
        ljgn: 2
        sjmn: drzm * dbpl
        sllz: 4
        pppw: cczh / lfqf
        lgvd: ljgn * ptdq
        drzm: hmdt - zczc
        hmdt: 32
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 152)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 301)
    }

    func test_day21() throws {
        let problem = try AoC_2022_Day21(.url(url(for: "2022_day21")))

        var answer = 158731561459602
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day21 / Part1 solution: \(answer)")

        answer = 3769668716709
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day21 / Part2 solution: \(answer)")
    }

    func test_day22_intro() throws {
        let problem = try AoC_2022_Day22(.string("""
                ...#
                .#..
                #...
                ....
        ...#.......#
        ........#...
        ..#....#....
        ..........#.
                ...#....
                .....#..
                .#......
                ......#.

        10R5L5R10L4R5L5
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 6032)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 5031)
    }

    func test_day22() throws {
        let problem = try AoC_2022_Day22(.url(url(for: "2022_day22")))

        var answer = 56372
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day22 / Part1 solution: \(answer)")

        answer = 197047
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day22 / Part2 solution: \(answer)")
    }

    func test_day23_intro1() throws {
        let problem = try AoC_2022_Day23(.string("""
        .....
        ..##.
        ..#..
        .....
        ..##.
        .....
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 25)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 4)
    }

    func test_day23_intro2() throws {
        let problem = try AoC_2022_Day23(.string("""
        ....#..
        ..###.#
        #...#.#
        .#...##
        #.###..
        ##.#.##
        .#..#..
        """))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 110)
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 20)
    }

    func test_day23() throws {
        let problem = try AoC_2022_Day23(.url(url(for: "2022_day23")))

        var answer = 4208
        var result = problem.solvePart1()
        XCTAssertEqual(result, answer)
        print("Day23 / Part1 solution: \(answer)")

        answer = 1016
        result = problem.solvePart2()
        XCTAssertEqual(result, answer)
        print("Day23 / Part2 solution: \(answer)")
    }
}
