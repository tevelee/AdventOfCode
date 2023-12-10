@testable import AoC_2023
import Testing

struct Day8 {
        struct Part1 {
        @Test
        func intro() throws {
            let problem = try AoC_2023_Day8("""
            RL

            AAA = (BBB, CCC)
            BBB = (DDD, EEE)
            CCC = (ZZZ, GGG)
            DDD = (DDD, DDD)
            EEE = (EEE, EEE)
            GGG = (GGG, GGG)
            ZZZ = (ZZZ, ZZZ)
            """)
            #expect(problem.solvePart1() == 2)
        }

        @Test
        func intro2() throws {
            let problem = try AoC_2023_Day8("""
            LLR

            AAA = (BBB, BBB)
            BBB = (AAA, ZZZ)
            ZZZ = (ZZZ, ZZZ)
            """)
            #expect(problem.solvePart1() == 6)
        }
    }

        struct Part2 {
        @Test
        func intro() throws {
            let problem = try AoC_2023_Day8("""
            LR

            11A = (11B, XXX)
            11B = (XXX, 11Z)
            11Z = (11B, XXX)
            22A = (22B, XXX)
            22B = (22C, 22C)
            22C = (22Z, 22Z)
            22Z = (22B, 22B)
            XXX = (XXX, XXX)
            """)
            #expect(problem.solvePart2() == 6)
        }
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try AoC_2023_Day8(file("2023_day8"))
        #expect(problem.solvePart1() == 14893)
        #expect(problem.solvePart2() == 10241191004509)
    }
}
