@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day15
extension CurrentPuzzle: Puzzle {}

private struct Day15 {
    @Test
    func intro() async throws {
        let problem = CurrentPuzzle("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
        #expect(try await problem.solvePart1() == 1320)
        #expect(try await problem.solvePart2() == 145)
    }

    @Test(.tags(.green))
    func live() async throws {
        let problem = try CurrentPuzzle()
        #expect(try await problem.solvePart1() == 513_158)
        #expect(try await problem.solvePart2() == 200_277)
    }
}
