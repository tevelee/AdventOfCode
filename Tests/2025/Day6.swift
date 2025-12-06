import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day6
extension CurrentPuzzle: Puzzle {}

private struct Day6 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        123 328  51 64 
         45 64  387 23 
          6 98  215 314
        *   +   *   +  
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 4_277_556)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 3_263_827)
    }

    @Suite(.tags(.live), .serialized)
    struct Day6Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 6 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 5_361_735_137_219)
        }
        
        @Test("Day 6 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 11_744_693_538_946)
        }
    }
}
