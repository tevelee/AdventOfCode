@testable import AoC_2023
import Testing

struct Day2 {
    @Test
    func intro() throws {
        let problem = try AoC_2023_Day2("""
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
        """)
        #expect(problem.solvePart1() == 8)
        #expect(problem.solvePart2() == 2286)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try AoC_2023_Day2()
        #expect(problem.solvePart1() == 2551)
        #expect(problem.solvePart2() == 62_811)
    }
}
