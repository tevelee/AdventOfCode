import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day3
extension CurrentPuzzle: Puzzle {}

private struct Day3 {
    private let problem: CurrentPuzzle
    init() {
        problem = CurrentPuzzle("""
        987654321111111
        811111111111119
        234234234234278
        818181911112111
        """)
    }
    @Test
    func part1_intro() async throws {
        try await #expect(problem.solvePart1() == 357)
    }

    @Test
    func part2_intro() async throws {
        try await #expect(problem.solvePart2() == 3121910778619)
    }

    @Suite(.tags(.live), .serialized)
    struct Day3Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 3 Part 1")
        func part1() async throws {
            try await #expect(problem.solvePart1() == 17_100)
        }
        
        @Test("Day 3 Part 2")
        func part2() async throws {
            try await #expect(problem.solvePart2() == 170_418_192_256_861)
        }
    }
}
