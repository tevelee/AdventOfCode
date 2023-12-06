import Utils

final class AoC_2023_Day6 {
    private let input: Input

    init(_ input: Input) {
        self.input = input
    }

    func solvePart1() throws -> Int {
        let (times, distances) = try parseSegments { $0.compactMap { Int($0) } }
        let races = zip(times, distances).map(Race.init)
        return races.product(of: numberOfWaysToBeat_procedual)
    }

    func solvePart2() throws -> Int {
        let (time, distance) = try parseSegments { $0.joined() }
        guard let time = Int(time), let distance = Int(distance) else { throw ParseError() }
        let race = Race(time: time, bestDistance: distance)
        return numberOfWaysToBeat_quadraticCalculation(race: race)
    }

    private func parseSegments<T>(_ transform: (Array<Substring>.SubSequence) -> T) throws -> (T, T) {
        let lines = try Array(input.wholeInput.lines)
        return (
            parse(input: lines[0], transform: transform),
            parse(input: lines[1], transform: transform)
        )
    }

    private func parse<T>(input: String, transform: (Array<Substring>.SubSequence) -> T) -> T {
        transform(input.split(separator: " ", omittingEmptySubsequences: true).dropFirst())
    }

    private func numberOfWaysToBeat_procedual(race: Race) -> Int {
        (0...race.time).count { start in
            start * (race.time - start) > race.bestDistance
        }
    }

    private func numberOfWaysToBeat_quadraticCalculation(race: Race) -> Int {
        // x * (t - x) > d
        // -x^2 + t*x - d = 0
        // t +/- sqrt(t^2 - 4*d) / 2
        let s = sqrt(Double(race.time * race.time - 4 * (race.bestDistance + 1)))
        let one = (Double(race.time) - s) / 2.0
        let two = (Double(race.time) + s) / 2.0
        return Int(two.rounded(.down)) - Int(one.rounded(.up)) + 1
    }
}

private struct Race {
    let time: Int
    let bestDistance: Int
}
