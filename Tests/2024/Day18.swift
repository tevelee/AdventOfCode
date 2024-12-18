import AoC_2024
import Testing
import Utils

private typealias CurrentPuzzle = AoC_2024_Day18
extension CurrentPuzzle: Puzzle {
    convenience init(_ input: Utils.Input) throws {
        try self.init(input, range: 0...70)
    }
}

private struct Day18 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        5,4
        4,2
        4,5
        3,0
        2,1
        6,3
        2,4
        1,5
        0,6
        3,3
        2,6
        5,1
        1,2
        5,5
        2,5
        6,5
        1,4
        0,4
        6,4
        1,1
        6,1
        1,0
        0,5
        1,6
        2,0
        """, range: 0...6)
        #expect(problem.solvePart1(limit: 12) == 22)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        5,4
        4,2
        4,5
        3,0
        2,1
        6,3
        2,4
        1,5
        0,6
        3,3
        2,6
        5,1
        1,2
        5,5
        2,5
        6,5
        1,4
        0,4
        6,4
        1,1
        6,1
        1,0
        0,5
        1,6
        2,0
        """, range: 0...6)
        #expect(problem.solvePart2() == "6,1")
    }

    @Suite(.tags(.live), .serialized)
    struct Day18Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 18 Part 1")
        func part1() {
            #expect(problem.solvePart1(limit: 1024) == 306)
        }
        
        @Test("Day 18 Part 2")
        func part2() {
            #expect(problem.solvePart2() == "38,63")
        }
    }
}
