@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day25
extension CurrentPuzzle: Puzzle {}

@Suite(.tags("debug1"))
private struct Day25 {
    @Test
    func intro1() throws {
        let problem = try CurrentPuzzle(#"""
        jqt: rhn xhk nvd
        rsh: frs pzl lsr
        xhk: hfx
        cmg: qnr nvd lhk bvb
        rhn: xhk bvb hfx
        bvb: xhk hfx
        pzl: lsr hfx nvd
        qnr: nvd
        ntq: jqt hfx bvb xhk
        nvd: lhk
        lsr: lhk
        rzs: qnr cmg lsr rsh
        frs: qnr lhk lsr
        """#)
        #expect(problem.solve() == 9 * 6)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solve() == 787 * 722)
    }
}
