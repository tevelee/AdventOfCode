@testable import AoC_2023
import Testing

private typealias CurrentPuzzle = AoC_2023_Day19
extension CurrentPuzzle: Puzzle {}

private struct Day19 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle(#"""
        px{a<2006:qkq,m>2090:A,rfg}
        pv{a>1716:R,A}
        lnx{m>1548:A,A}
        rfg{s<537:gd,x>2440:R,A}
        qs{s>3448:A,lnx}
        qkq{x<1416:A,crn}
        crn{x>2662:A,R}
        in{s<1351:px,qqz}
        qqz{s>2770:qs,m<1801:hdj,R}
        gd{a>3333:R,R}
        hdj{m>838:A,pv}

        {x=787,m=2655,a=1222,s=2876}
        {x=1679,m=44,a=2067,s=496}
        {x=2036,m=264,a=79,s=2244}
        {x=2461,m=1339,a=466,s=291}
        {x=2127,m=1623,a=2188,s=1013}
        """#)
        #expect(problem.solvePart1() == 19_114)
        #expect(problem.solvePart2() == 167_409_079_868_000)
    }

    @Test(.tags(.green))
    func live() throws {
        let problem = try CurrentPuzzle()
        #expect(problem.solvePart1() == 325_952)
        #expect(problem.solvePart2() == 125_744_206_494_820)
    }
}
