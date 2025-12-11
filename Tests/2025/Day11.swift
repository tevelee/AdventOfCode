import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day11
extension CurrentPuzzle: Puzzle {}

private struct Day11 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        aaa: you hhh
        you: bbb ccc
        bbb: ddd eee
        ccc: ddd eee fff
        ddd: ggg
        eee: out
        fff: out
        ggg: out
        hhh: ccc fff iii
        iii: out
        """)
        #expect(problem.solvePart1() == 5)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        svr: aaa bbb
        aaa: fft
        fft: ccc
        bbb: tty
        tty: ccc
        ccc: ddd eee
        ddd: hub
        hub: fff
        eee: dac
        dac: fff
        fff: ggg hhh
        ggg: out
        hhh: out
        """)
        #expect(problem.solvePart2() == 2)
    }

    @Suite(.tags(.live), .serialized)
    struct Day11Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 11 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 571)
        }
        
        @Test("Day 11 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 511_378_159_390_560)
        }
    }
}
