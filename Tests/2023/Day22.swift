@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day22
extension CurrentPuzzle: Puzzle {}

@Suite(.tags("debug"))
private struct Day22 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        1,0,1~1,2,1
        0,0,2~2,0,2
        0,2,3~2,2,3
        0,0,4~0,2,4
        2,0,5~2,2,5
        0,1,6~2,1,6
        1,1,8~1,1,9
        """#)
        #expect(problem.solvePart1() == 5)
        #expect(problem.solvePart2() == 7)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 386)
        #expect(problem.solvePart2() == 39_933)
    }
}
