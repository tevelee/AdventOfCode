import Algorithms
import Utils

final class AoC_2023_Day20 {
    private let machine: Machine

    init(_ input: Input) throws {
        machine = try Machine(input: input)
    }
    
    func solvePart1() -> Int {
        machine.reset()
        for _ in 1...1000 {
            machine.pushButton()
        }
        return machine.pulsesSent.product(of: \.value)
    }

    func solvePart2() -> Int {
        numberOfIterationsRequired(
            for: desiredModulePulseCombination(for: ["rx": .low])
        )
        .lowestCommonMultiple(of: \.value)
    }

    private func numberOfIterationsRequired(for desiredState: [String: Pulse]) -> [String: Int] {
        machine.reset()
        var numberOfIterationsRequiredPerModule = desiredState.mapValues { _ in 0 }
        var iteration = 0
        while numberOfIterationsRequiredPerModule.values.contains(0) {
            iteration += 1
            machine.pushButton { instruction in
                if numberOfIterationsRequiredPerModule[instruction.destination] == 0, desiredState[instruction.destination] == instruction.pulse {
                    numberOfIterationsRequiredPerModule[instruction.destination] = iteration
                }
            }
        }
        return numberOfIterationsRequiredPerModule
    }

    private func desiredModulePulseCombination(for desiredState: [String : Pulse]) -> [String : Pulse] {
        var desiredState = desiredState
        search: while true {
            let inputs = desiredState.keys.flatMap(machine.inputs).sorted()
            let pulseCombinations = Array(repeating: Pulse.allCases, count: inputs.count).flatMap { $0 }.uniquePermutations(ofCount: inputs.count)
            for combination in pulseCombinations {
                let modulePulseCombination = zip(inputs, combination).map { (module: $0, pulse: $1) }
                let instructions = modulePulseCombination.map {
                    Machine.Instruction(
                        sender: machine.inputs(of: $0.module).first!,
                        pulse: $0.pulse,
                        destination: $0.module
                    )
                }
                var canFulfillGoal = false
                machine.reset()
                machine.send(instructions: instructions) {
                    if desiredState[$0.destination] == $0.pulse {
                        canFulfillGoal = true
                    }
                }
                desiredState = Dictionary(uniqueKeysWithValues: modulePulseCombination)
                if canFulfillGoal {
                    break search
                }
            }
        }
        return desiredState
    }


}

private final class Machine {
    private lazy var modules: [String: Module] = createModules()
    private var inputs: [String: Set<String>] = [:]
    private var outputs: [String: [String]] = [:]
    private var types: [String: Character?] = [:]
    var pulsesSent: [Pulse: Int] = [:]

    init(input: Input) throws {
        for entry in try input.wholeInput.lines {
            var (name, list) = try entry.split(" -> ").elements()
            let output = list.split(", ")
            let prefix: Character = if name.hasPrefix("&") || name.hasPrefix("%") {
                name.removeFirst()
            } else {
                "-"
            }
            types[name] = prefix
            outputs[name] = output
            for module in output {
                inputs[module, default: []].insert(name)
            }
        }
    }

    private func createModules() -> [String: Module] {
        types.map { name, prefix in
            let factory = switch prefix {
            case "%":
                FlipFlop.init
            case "&":
                Conjunction.init
            default:
                Broadcaster.init
            }
            return factory(name, inputs[name, default: []], outputs[name]!)
        }.keyed(by: \.name)
    }

    func reset() {
        modules = createModules()
    }

    func pushButton(evaluate: ((Instruction) -> Void)? = nil) {
        send(instructions: [Instruction(sender: "button", pulse: .low, destination: "broadcaster")], evaluate: evaluate)
    }

    func send(instructions: [Instruction], evaluate: ((Instruction) -> Void)? = nil) {
        var instructions = instructions
        while !instructions.isEmpty {
            let instruction = instructions.removeFirst()
            evaluate?(instruction)
            pulsesSent[instruction.pulse, default: 0] += 1
            if let module = modules[instruction.destination],
               let pulse = module.handle(pulse: instruction.pulse, from: instruction.sender) {
                instructions += module.outputs.map { Instruction(sender: instruction.destination, pulse: pulse, destination: $0) }
            }
        }
    }

    func inputs(of module: String) -> some Collection<String> {
        modules.filter { $0.value.outputs.contains(module) }.keys
    }

    struct Instruction: CustomStringConvertible {
        let sender: String
        let pulse: Pulse
        let destination: String

        var description: String {
            "\(sender) -\(pulse)-> \(destination)"
        }
    }

    private class Module {
        var name: String
        var inputs: Set<String>
        var outputs: [String]

        init(name: String, inputs: Set<String>, outputs: [String]) {
            self.name = name
            self.inputs = inputs
            self.outputs = outputs
        }

        func handle(pulse: Pulse, from module: String) -> Pulse? { nil }
    }

    private final class FlipFlop: Module {
        private var isOn = false

        override func handle(pulse: Pulse, from module: String) -> Pulse? {
            switch pulse {
            case .low:
                isOn.toggle()
                return isOn ? .high : .low
            case .high:
                return nil
            }
        }
    }

    private final class Conjunction: Module {
        private var memory: [String: Pulse] = [:]

        override func handle(pulse: Pulse, from module: String) -> Pulse {
            memory[module] = pulse
            return inputs.allSatisfy { memory[$0, default: .low] == .high } ? .low : .high
        }
    }

    private final class Broadcaster: Module {
        override func handle(pulse: Pulse, from module: String) -> Pulse {
            pulse
        }
    }
}

private enum Pulse: CaseIterable {
    case low, high
}
