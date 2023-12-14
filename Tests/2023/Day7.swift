@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day7
extension CurrentPuzzle: Puzzle {}

private struct Day7 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        32T3K 765
        T55J5 684
        KK677 28
        KTJJT 220
        QQQJA 483
        """)
        #expect(problem.solvePart1() == 6440)
        #expect(problem.solvePart2() == 5905)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 249_638_405)
        #expect(problem.solvePart2() == 249_776_650)
    }
}
