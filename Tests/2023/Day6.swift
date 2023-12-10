@testable import AoC_2023
import Testing

struct Day6 {
    @Test
    func intro() throws {
        let problem = AoC_2023_Day6("""
        Time:      7  15   30
        Distance:  9  40  200
        """)
        #expect(try problem.solvePart1() == 288)
        #expect(try problem.solvePart2() == 71503)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try AoC_2023_Day6(file("2023_day6"))
        #expect(try problem.solvePart1() == 138915)
        #expect(try problem.solvePart2() == 27340847)
    }
}

