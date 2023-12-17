@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day16
extension CurrentPuzzle: Puzzle {}

private struct Day16 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle(#"""
        .|...\....
        |.-.\.....
        .....|-...
        ........|.
        ..........
        .........\
        ..../.\\..
        .-.-/..|..
        .|....-|.\
        ..//.|....
        """#)
        #expect(problem.solvePart1() == 46)
        #expect(problem.solvePart2() == 51)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 7927)
        #expect(problem.solvePart2() == 8246)
    }
}
