import AoC_2020
import XCTest

final class AoC_2020_Tests: XCTestCase {
    func url(for fileName: String, fileExtension: String = "txt") throws -> URL {
        try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
    }

    func test_day1() async throws {
        let problem = try AoC_2020_Day1(url(for: "2020_day1"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 1007331)
        print("Day1 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 48914340)
        print("Day1 / Part2 solution: \(part2)")
    }

    func test_day2() async throws {
        let problem = try AoC_2020_Day2(url(for: "2020_day2"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 445)
        print("Day2 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 491)
        print("Day2 / Part2 solution: \(part2)")
    }

    func test_day3() async throws {
        let problem = try AoC_2020_Day3(url(for: "2020_day3"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 299)
        print("Day3 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3621285278)
        print("Day3 / Part2 solution: \(part2)")
    }

    func test_day4_intro() {
        let problem = AoC_2020_Day4("""
        ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
        byr:1937 iyr:2017 cid:147 hgt:183cm

        iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
        hcl:#cfa07d byr:1929

        hcl:#ae17e1 iyr:2013
        eyr:2024
        ecl:brn pid:760753108 byr:1931
        hgt:179cm

        hcl:#cfa07d eyr:2025 pid:166559648
        iyr:2011 ecl:brn hgt:59in
        """)
        XCTAssertEqual(problem.solvePart1(), 2)
    }

    func test_day4_intro_part2_invalid() {
        let problem = AoC_2020_Day4("""
        eyr:1972 cid:100
        hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

        iyr:2019
        hcl:#602927 eyr:1967 hgt:170cm
        ecl:grn pid:012533040 byr:1946

        hcl:dab227 iyr:2012
        ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

        hgt:59cm ecl:zzz
        eyr:2038 hcl:74454a iyr:2023
        pid:3556412378 byr:2007
        """)
        XCTAssertEqual(problem.solvePart2(), 0)
    }

    func test_day4_intro_part2_valid() {
        let problem = AoC_2020_Day4("""
        pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
        hcl:#623a2f

        eyr:2029 ecl:blu cid:129 byr:1989
        iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

        hcl:#888785
        hgt:164cm byr:2001 iyr:2015 cid:88
        pid:545766238 ecl:hzl
        eyr:2022

        iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
        """)
        XCTAssertEqual(problem.solvePart2(), 4)
    }

    func test_day4() throws {
        let problem = try AoC_2020_Day4(url(for: "2020_day4"))
        let part1 = problem.solvePart1()
        XCTAssertEqual(part1, 219)
        print("Day4 / Part1 solution: \(part1)")
        let part2 = problem.solvePart2()
        XCTAssertEqual(part2, 127)
        print("Day4 / Part2 solution: \(part2)")
    }

    func test_day5() async throws {
        let problem = try AoC_2020_Day5(url(for: "2020_day5"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 880)
        print("Day5 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 731)
        print("Day5 / Part2 solution: \(part2)")
    }

    func test_day6() async throws {
        let problem = try AoC_2020_Day6(url(for: "2020_day6"))
        let part1 = try await problem.solvePart1()
        XCTAssertEqual(part1, 6782)
        print("Day6 / Part1 solution: \(part1)")
        let part2 = try await problem.solvePart2()
        XCTAssertEqual(part2, 3596)
        print("Day6 / Part2 solution: \(part2)")
    }
}
