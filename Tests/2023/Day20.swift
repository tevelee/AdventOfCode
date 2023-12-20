@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day20
extension CurrentPuzzle: Puzzle {}

private struct Day20 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        broadcaster -> a, b, c
        %a -> b
        %b -> c
        %c -> inv
        &inv -> a
        """#)
        #expect(problem.solvePart1() == 32_000_000)
    }

    @Test
    func intro2() throws {
        let problem = try CurrentPuzzle(#"""
        broadcaster -> a
        %a -> inv, con
        &inv -> b
        %b -> con
        &con -> output
        """#)
        #expect(problem.solvePart1() == 11_687_500)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 814_934_624)
        #expect(problem.solvePart2() == 228_282_646_835_717)
    }
}
