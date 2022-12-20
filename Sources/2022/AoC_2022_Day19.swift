import Utils

public final class AoC_2022_Day19 {
    private let blueprints: [Blueprint]

    public init(_ input: Input) throws {
        blueprints = try input.wholeInput.lines.map(Blueprint.init)
    }

    public func solvePart1() -> Int {
        let state = State(minutesRemaining: 24, robots: [.ore: 1])
        return blueprints.sum { blueprint in
            let result = maxGeodes(using: blueprint, at: state)
            print(blueprint.id, result.score, result.builds.map(\.rawValue))
            return blueprint.id * result.score
        }
    }

    public func solvePart2() -> Int {
        let state = State(minutesRemaining: 32, robots: [.ore: 1])
        return blueprints.prefix(3).product { blueprint in
            let result = maxGeodes(using: blueprint, at: state)
            print(blueprint.id, result.score, result.builds.map(\.rawValue))
            return result.score
        }
    }

    private struct State: Hashable {
        var minutesRemaining: Int
        var robots: Resources
        var resources: Resources = [:]

        func apply(_ block: (inout State) -> Void) -> State {
            var copy = self
            block(&copy)
            return copy
        }

        func hasRobot(building resource: Resource) -> Bool {
            robots[resource] > 0
        }

        mutating func advance(minutes: Int) {
            minutesRemaining -= minutes
            resources += robots * minutes
        }

        mutating func build(robot: Resource, from blueprint: Blueprint) {
            resources -= blueprint[robot]
            robots[robot] += 1
        }
    }

    private func maxGeodes(using blueprint: Blueprint, at state: State, builds: [Resource] = []) -> (score: Int, builds: [Resource]) {
        if state.minutesRemaining == 0 {
            let score = state.resources[.geode]
            return (score, builds)
        }
        var max: (score: Int, [Resource]) = (0, [])
        let scoreIfNotBuildingAnyMoreRobots = maxGeodes(using: blueprint, at: state.apply {
            $0.advance(minutes: state.minutesRemaining)
        }, builds: builds)
        if scoreIfNotBuildingAnyMoreRobots.score > max.score {
            max = scoreIfNotBuildingAnyMoreRobots
        }
        var robotsToBuildNext: [Resource] = Resource.allCases
            .reversed()
            .filter { blueprint.canBuild(robot: $0, usingRobots: state.robots) }
            .filter { $0 == .geode || state.robots[$0] < blueprint.max[$0] }
        if state.robots[.obsidian] > 0, let index = robotsToBuildNext.firstIndex(of: .ore) {
            robotsToBuildNext.remove(at: index)
        }
        for robotType in robotsToBuildNext {
            let roundsNeeded = blueprint.roundsNeeded(toBuild: robotType, from: state.resources, with: state.robots)
            if roundsNeeded > state.minutesRemaining {
                continue
            }
            let score = maxGeodes(using: blueprint, at: state.apply {
                $0.advance(minutes: roundsNeeded)
                $0.build(robot: robotType, from: blueprint)
            }, builds: builds + [robotType])
            if score.score > max.score {
                max = score
            }
        }
        return max
    }
}

private struct ParseError: Error {}

private struct Blueprint {
    let id: Int
    private let costs: [Resource: Resources]
    var max: Resources

    init(_ string: String) throws {
        let regex = /Blueprint (?<id>\d+): Each ore robot costs (?<ore>\d+) ore. Each clay robot costs (?<clay>\d+) ore. Each obsidian robot costs (?<obsidianOre>\d+) ore and (?<obsidianClay>\d+) clay. Each geode robot costs (?<geodeOre>\d+) ore and (?<geodeObsidian>\d+) obsidian./
        guard let output = string.wholeMatch(of: regex)?.output,
              let id = Int(output.id),
              let ore = Int(output.ore),
              let clay = Int(output.clay),
              let obsidianOre = Int(output.obsidianOre),
              let obsidianClay = Int(output.obsidianClay),
              let geodeOre = Int(output.geodeOre),
              let geodeObsidian = Int(output.geodeObsidian) else {
            throw ParseError()
        }
        self.id = id
        costs = [
            .ore: [.ore: ore],
            .clay: [.ore: clay],
            .obsidian: [.ore: obsidianOre, .clay: obsidianClay],
            .geode: [.ore: geodeOre, .obsidian: geodeObsidian]
        ]
        max = [
            .ore: costs.map { $0.value[.ore] }.max() ?? 0,
            .clay: costs.map { $0.value[.clay] }.max() ?? 0,
            .obsidian: costs.map { $0.value[.obsidian] }.max() ?? 0,
            .geode: costs.map { $0.value[.geode] }.max() ?? 0,
        ]
    }

    subscript(resource: Resource) -> Resources {
        costs[resource, default: Resources()]
    }

    func canBuild(robot: Resource, usingRobots resources: Resources) -> Bool {
        self[robot].types.allSatisfy { resources[$0] > 0 }
    }

    func roundsNeeded(toBuild robot: Resource, from resources: Resources, with robots: Resources) -> Int {
        for rounds in 0... where self[robot] <= resources + (robots * rounds)  {
            return rounds + 1
        }
        return 1
    }
}

private enum Resource: String, Hashable, CaseIterable {
    case ore
    case clay
    case obsidian
    case geode
}

private struct Resources: Hashable, ExpressibleByDictionaryLiteral {
    private var values: [Resource: Int]

    init(dictionaryLiteral elements: (Resource, Int)...) {
        values = Dictionary(uniqueKeysWithValues: elements)
    }

    private init(values: [Resource: Int]) {
        self.values = values
    }

    subscript(resource: Resource) -> Int {
        get {
            values[resource, default: 0]
        }
        set {
            values[resource] = newValue
        }
    }

    var types: some Sequence<Resource> {
        values.keys
    }

    static func op(_ lhs: Resources, _ rhs: Resources, _ op: (inout Resources, Resources) -> Void) -> Resources {
        var copy = lhs
        op(&copy, rhs)
        return copy
    }

    static func op(_ lhs: inout Resources, _ rhs: Resources, _ op: (inout Int, Int) -> Void) {
        for resource in Resource.allCases {
            op(&lhs[resource], rhs[resource])
        }
    }

    static func - (lhs: Resources, rhs: Resources) -> Resources {
        op(lhs, rhs, -=)
    }

    static func -= (lhs: inout Resources, rhs: Resources) {
        op(&lhs, rhs, -=)
    }

    static func + (lhs: Resources, rhs: Resources) -> Resources {
        op(lhs, rhs, +=)
    }

    static func += (lhs: inout Resources, rhs: Resources) {
        op(&lhs, rhs, +=)
    }

    static func * (lhs: Resources, rhs: Resources) -> Resources {
        op(lhs, rhs, *=)
    }

    static func *= (lhs: inout Resources, rhs: Resources) {
        op(&lhs, rhs, *=)
    }

    static func <= (lhs: Resources, rhs: Resources) -> Bool {
        Resource.allCases.allSatisfy { resource in
            lhs[resource] <= rhs[resource]
        }
    }

    static func * (lhs: Resources, rhs: Int) -> Resources {
        var copy = lhs
        copy *= rhs
        return copy
    }

    static func *= (lhs: inout Resources, rhs: Int) {
        for resource in Resource.allCases {
            lhs[resource] *= rhs
        }
    }
}
