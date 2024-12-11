import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day11
extension CurrentPuzzle: Puzzle {}

private struct Day11 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle("0 1 10 99 999")
        #expect(problem.solve(times: 1) == 7)
    }

    @Test
    func intro2() throws {
        let problem = try CurrentPuzzle("125 17")
        #expect(problem.solve(times: 6) == 22)
    }

    @Test
    func intro3() throws {
        let problem = try CurrentPuzzle("125 17")
        #expect(problem.solve(times: 25) == 55312)
    }

    @Suite(.tags(.live), .serialized)
    struct Day11Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 11 Part 1")
        func part1() {
            #expect(problem.solve(times: 25) == 217_812)
        }
        
        @Test("Day 11 Part 2")
        func part2() {
            #expect(problem.solve(times: 75) == 259_112_729_857_522)
        }
    }
}
