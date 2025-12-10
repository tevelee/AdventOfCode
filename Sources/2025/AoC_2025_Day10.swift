import Utils

public final class AoC_2025_Day10 {
    private let machines: [Machine]

    public init(_ input: Input) throws {
        machines = try input.wholeInput.lines
            .compactMap { line -> Machine? in
                guard let match = try /\[(?<lights>.*?)\] (?<buttons>.*?) \{(?<joltages>.*?)\}/.wholeMatch(in: line)?.output else { return nil }
                let lights = match.lights.map { $0 == "#" }
                let joltages = match.joltages.integers
                precondition(lights.count == joltages.count)
                let buttons = match.buttons.matches(of: /\(.*?\)/).map { Set($0.output.integers) }
                return Machine(lights: lights, buttons: buttons, joltages: joltages)
            }
    }

    public func solvePart1() -> Int {
        machines.sum { minButtonPressesForLights($0) }
    }

    public func solvePart2() -> Int {
        machines.sum { minButtonPressesForJoltages($0) }
    }

    private func minButtonPressesForLights(_ machine: Machine) -> Int {
        let initial: Machine.Lights = Array(repeating: false, count: machine.lights.count)
        var visited: Set = [initial]

        var queue: [(lights: Machine.Lights, depth: Int)] = [(initial, 0)]
        while let (state, depth) = queue.first {
            queue.removeFirst()
            for button in machine.buttons {
                let next = press(button: button, on: state)
                if next == machine.lights {
                    return depth + 1
                }
                if visited.insert(next).inserted {
                    queue.append((next, depth + 1))
                }
            }
        }
        return 0
    }

//    private func minButtonPressesForJoltages(_ machine: Machine) -> Int {
//        let gcd = greatestCommonDivisor(of: machine.joltages)
//        var machine = machine
//        for index in machine.joltages.indices {
//            machine.joltages[index] /= gcd
//        }
//        return _minButtonPressesForJoltages(machine) * gcd
//    }

    private func minButtonPressesForJoltages(_ machine: Machine) -> Int {
        print(machine.lights)
        let initial: [Int] = Array(repeating: 0, count: machine.lights.count)
        var visited: Set = [initial]

        var queue: [(counts: [Int], depth: Int)] = [(initial, 0)]
        while let (state, depth) = queue.first {
            queue.removeFirst()
            for button in machine.buttons {
                let next = press(button: button, on: state)
                if next == machine.joltages {
                    return depth + 1
                }
                if zip(next, machine.joltages).allSatisfy(<=), visited.insert(next).inserted {
                    queue.append((next, depth + 1))
                }
            }
        }
        return 0
    }

    private func press(button: Machine.Button, on state: Machine.Lights) -> Machine.Lights {
        var state = state
        for index in button {
            state[index].toggle()
        }
        return state
    }

    private func press(button: Machine.Button, on state: [Int], times: Int = 1) -> [Int] {
        var state = state
        for index in button {
            state[index] += times
        }
        return state
    }
}

private struct Machine {
    typealias Lights = [Bool]
    typealias Button = Set<Int>
    let lights: Lights
    let buttons: [Button]
    var joltages: [Int]
}
