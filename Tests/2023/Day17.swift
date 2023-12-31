@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day17
extension CurrentPuzzle: Puzzle {}

private struct Day17 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle(#"""
        2413432311323
        3215453535623
        3255245654254
        3446585845452
        4546657867536
        1438598798454
        4457876987766
        3637877979653
        4654967986887
        4564679986453
        1224686865563
        2546548887735
        4322674655533
        """#)
        #expect(problem.solvePart1() == 102)
        #expect(problem.solvePart2() == 94)
    }

    @Test
    func intro2() throws {
        let problem = try CurrentPuzzle(#"""
        111111111111
        999999999991
        999999999991
        999999999991
        999999999991
        """#)
        #expect(problem.solvePart1() == 59)
        #expect(problem.solvePart2() == 71)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 785)
        #expect(problem.solvePart2() == 922)
    }
}
