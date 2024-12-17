import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day17
extension CurrentPuzzle: Puzzle {}

private struct Day17 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        Register A: 729
        Register B: 0
        Register C: 0
        
        Program: 0,1,5,4,3,0
        """)
        #expect(problem.solvePart1() == "4,6,3,5,6,3,5,2,1,0")
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        Register A: 2024
        Register B: 0
        Register C: 0
        
        Program: 0,3,5,4,3,0
        """)
        #expect(problem.solvePart2() == 117_440)
    }

    @Suite(.tags(.live), .serialized)
    struct Day17Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 17 Part 1")
        func part1() {
            #expect(problem.solvePart1() == "6,4,6,0,4,5,7,2,7")
        }
        
        @Test("Day 17 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 164_541_160_582_845)
        }
    }
}
