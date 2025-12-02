import AoC_2025
import Testing

private typealias CurrentPuzzle = AoC_2025_Day2
extension CurrentPuzzle: Puzzle {}

@MainActor
private struct Day2 {
    private let problem: CurrentPuzzle
    init() throws {
        problem = try CurrentPuzzle("""
        11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
        1698522-1698528,446443-446449,38593856-38593862,565653-565659,
        824824821-824824827,2121212118-2121212124
        """)
    }

    @Test
    func part1_intro() {
        #expect(problem.solvePart1() == 1_227_775_554)
    }

    @Test
    func part2_intro() {
        #expect(problem.solvePart2() == 4_174_379_265)
    }

    @MainActor
    @Suite(.tags(.live), .serialized)
    struct Day2Live {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }
        
        @Test("Day 2 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 38_310_256_125)
        }
        
        @Test("Day 2 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 58_961_152_806)
        }
    }
}
