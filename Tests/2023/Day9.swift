@testable import AoC_2023
import Testing

struct Day9 {
    @Test
    func intro() async throws {
        let problem = AoC_2023_Day9("""
        0 3 6 9 12 15
        1 3 6 10 15 21
        10 13 16 21 30 45
        """)
        #expect(try await problem.solvePart1() == 114)
        #expect(try await problem.solvePart2() == 2)
    }

    @Test(.tags(.green))
    func live() async throws {
        let problem = try AoC_2023_Day9(file("2023_day9"))
        #expect(try await problem.solvePart1() == 1930746032)
        #expect(try await problem.solvePart2() == 1154)
    }
}
