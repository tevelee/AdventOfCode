import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day25
extension CurrentPuzzle: Puzzle {}

private struct Day25 {
    @Test
    func intro() throws {
        let problem = try CurrentPuzzle("""
        #####
        .####
        .####
        .####
        .#.#.
        .#...
        .....
        
        #####
        ##.##
        .#.##
        ...##
        ...#.
        ...#.
        .....
        
        .....
        #....
        #....
        #...#
        #.#.#
        #.###
        #####
        
        .....
        .....
        #.#..
        ###..
        ###.#
        ###.#
        #####
        
        .....
        .....
        .....
        #....
        #.#..
        #.#.#
        #####
        """)
        #expect(problem.solve() == 3)
    }

    @Suite(.tags(.live), .serialized)
    struct Day25Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 25")
        func live() {
            #expect(problem.solve() == 3_057)
        }
    }
}
