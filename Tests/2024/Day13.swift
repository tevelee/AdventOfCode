import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day13
extension CurrentPuzzle: Puzzle {}

private struct Day13 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
        
        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176
        
        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450
        
        Button A: X+69, Y+23
        Button B: X+27, Y+71
        Prize: X=18641, Y=10279
        """)
        #expect(problem.solvePart1() == 480)
    }

    @Suite(.tags(.live), .serialized)
    struct Day13Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 13 Part 1")
        func part1() throws {
            #expect(problem.solvePart1() == 32_026)
        }
        
        @Test("Day 13 Part 2")
        func part2() throws {
            #expect(problem.solvePart2() == 89_013_607_072_065)
        }
    }
}
