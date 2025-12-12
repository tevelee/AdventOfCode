import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day12
extension CurrentPuzzle: Puzzle {}

private struct Day12 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        0:
        ###
        ##.
        ##.

        1:
        ###
        ##.
        .##

        2:
        .##
        ###
        ##.

        3:
        ##.
        ###
        ##.

        4:
        ###
        #..
        ###

        5:
        ###
        .#.
        ###

        4x4: 0 0 0 0 2 0
        12x5: 1 0 1 0 2 2
        12x5: 1 0 1 0 3 2
        """)
        #expect(problem.solvePart1() == 1)
    }

    @Suite(.tags(.live), .serialized)
    struct Day12Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 12 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 541)
        }
    }
}
