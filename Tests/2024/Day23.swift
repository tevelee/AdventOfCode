import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day23
extension CurrentPuzzle: Puzzle {}

private struct Day23 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        kh-tc
        qp-kh
        de-cg
        ka-co
        yn-aq
        qp-ub
        cg-tb
        vc-aq
        tb-ka
        wh-tc
        yn-cg
        kh-ub
        ta-co
        de-co
        tc-td
        tb-wq
        wh-td
        ta-ka
        td-qp
        aq-cg
        wq-ub
        ub-vc
        de-ta
        wq-aq
        wq-vc
        wh-yn
        ka-de
        kh-ta
        co-tc
        wh-qp
        tb-vc
        td-yn
        """)
        #expect(problem.solvePart1() == 7)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        kh-tc
        qp-kh
        de-cg
        ka-co
        yn-aq
        qp-ub
        cg-tb
        vc-aq
        tb-ka
        wh-tc
        yn-cg
        kh-ub
        ta-co
        de-co
        tc-td
        tb-wq
        wh-td
        ta-ka
        td-qp
        aq-cg
        wq-ub
        ub-vc
        de-ta
        wq-aq
        wq-vc
        wh-yn
        ka-de
        kh-ta
        co-tc
        wh-qp
        tb-vc
        td-yn
        """)
        #expect(problem.solvePart2() == "co,de,ka,ta")
    }

    @Suite(.tags(.live), .serialized)
    struct Day23Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 23 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 1_366)
        }
        
        @Test("Day 23 Part 2")
        func part2() {
            #expect(problem.solvePart2() == "bs,cf,cn,gb,gk,jf,mp,qk,qo,st,ti,uc,xw")
        }
    }
}
