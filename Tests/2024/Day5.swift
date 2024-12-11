import AoC_2024
import Testing

private typealias CurrentPuzzle = AoC_2024_Day5
extension CurrentPuzzle: Puzzle {}

private struct Day5 {
    @Test
    func part1_intro() throws {
        let problem = try CurrentPuzzle("""
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13
        
        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """)
        #expect(problem.solvePart1() == 143)
    }

    @Test
    func part2_intro() throws {
        let problem = try CurrentPuzzle("""
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13
        
        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """)
        #expect(problem.solvePart2() == 123)
    }

    @Suite(.tags(.live), .serialized)
    struct Day5Live: @unchecked Sendable {
        private let problem: CurrentPuzzle
        init() async throws {
            problem = try await CurrentPuzzle()
        }

        @Test("Day 5 Part 1")
        func part1() {
            #expect(problem.solvePart1() == 5_991)
        }

        @Test("Day 5 Part 2")
        func part2() {
            #expect(problem.solvePart2() == 5_479)
        }
    }
}
