import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day8
extension CurrentPuzzle: Puzzle {}

private struct Day8 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        162,817,812
        57,618,57
        906,360,560
        592,479,940
        352,342,300
        466,668,158
        542,29,236
        431,825,988
        739,650,466
        52,470,668
        216,146,977
        819,987,18
        117,168,530
        805,96,715
        346,949,466
        970,615,88
        941,993,340
        862,61,35
        984,92,344
        425,690,689
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1(until: 10) == 40)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 25_272)
    }

    @Suite(.tags(.live), .serialized)
    struct Day8Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 8 Part 1")
        func part1() {
            #expect(problem.solvePart1(until: 1000) == 63_920)
        }
        
        @Test("Day 8 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 1_026_594_680)
        }
    }
}
