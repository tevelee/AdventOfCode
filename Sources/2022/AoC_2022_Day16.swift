import Utils

public final class AoC_2022_Day16 {
    private let valves: [String: Valve]
    private let initialValve = "AA"

    private lazy var shortestPaths = FloydWarshall(nodes: valves.mapValues { valve in
        Set(valve.connections.map { .init(node: $0, weight: 1) })
    }).shortestPaths

    public init(_ input: Input) throws {
        let valves: [Valve] = try input.wholeInput.lines.map { line in
            guard let output = line.wholeMatch(of: /Valve (?<name>\w+) has flow rate=(?<rate>\d+); (tunnels lead to valves|tunnel leads to valve) (?<connections>.*)/)?.output,
                  let rate = Int(output.rate) else {
                throw ParseError()
            }
            return Valve(name: String(output.name),
                         flowRate: rate,
                         connections: Set(output.connections.split(separator: ", ").map { String($0) }))
        }
        self.valves = Dictionary(grouping: valves, by: \.name).compactMapValues(\.first)
    }

    public func solvePart1() -> Int {
        solve(totalTime: 30)
    }

    public func solvePart2() -> Int {
        solve(totalTime: 26, additionalActor: true)
    }

    private func solve(totalTime: Int, additionalActor: Bool = false) -> Int {
        var maxPressureReleased = 0
        explore(valve: initialValve,
                visitedValves: Set(valves.filter { $0.value.flowRate == 0 }.map(\.key)),
                totalPressureReleased: 0,
                maxPressureReleased: &maxPressureReleased,
                totalTime: totalTime,
                timeRemaining: totalTime,
                additionalActor: additionalActor)
        return maxPressureReleased
    }

    private func explore(valve currentValve: String,
                         visitedValves: Set<String>,
                         totalPressureReleased: Int,
                         maxPressureReleased: inout Int,
                         totalTime: Int,
                         timeRemaining: Int,
                         additionalActor: Bool = false) {
        maxPressureReleased = max(maxPressureReleased, totalPressureReleased)
        for (valve, distance) in shortestPaths[currentValve]! {
            let newTimeRemining = timeRemaining - distance - 1
            if !visitedValves.contains(valve), newTimeRemining > 0 {
                let pressureReleased = newTimeRemining * valves[valve]!.flowRate
                explore(valve: valve,
                        visitedValves: visitedValves + valve,
                        totalPressureReleased: totalPressureReleased + pressureReleased,
                        maxPressureReleased: &maxPressureReleased,
                        totalTime: totalTime,
                        timeRemaining: newTimeRemining,
                        additionalActor: additionalActor
                )
            }
        }
        if additionalActor {
            explore(valve: initialValve,
                    visitedValves: visitedValves,
                    totalPressureReleased: totalPressureReleased,
                    maxPressureReleased: &maxPressureReleased,
                    totalTime: totalTime,
                    timeRemaining: totalTime,
                    additionalActor: false)
        }
    }
}

private struct ParseError: Error {}

private struct Valve {
    let name: String
    let flowRate: Int
    let connections: Set<String>
}
