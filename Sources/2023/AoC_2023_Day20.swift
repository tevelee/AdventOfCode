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
        let rxInputs = machine.inputs(of: "rx")
        guard rxInputs.count == 1, let conjunctionInput = rxInputs.first, machine.isConjunction(conjunctionInput) else {
            fatalError("My input graph has only one conjunction input of the reset module. In order to output a low pulse, all their input needs to be high")
        }
        let inputModules = machine.inputs(of: conjunctionInput)
        guard inputModules.allSatisfy(machine.isInverter) else {
            fatalError("All those modules are inverters, so I'll look for when they receive a low pulse to output a high")
        }
        var inputModuleMap = Dictionary(uniqueKeysWithValues: inputModules.map { ($0, 0) })

        machine.reset()

        var iteration = 0
        while inputModuleMap.values.contains(0) {
            iteration += 1
            machine.pushButton { instruction in
                if inputModuleMap[instruction.destination] == 0, instruction.pulse == .low {
                    inputModuleMap[instruction.destination] = iteration
                }
            }
        }
        
        return inputModuleMap.lowestCommonMultiple(of: \.value)
    }
}

private final class Machine {
    private let modules: [String: Module]
    var pulsesSent: [Pulse: Int] = [:]

    init(input: Input) throws {
        var inputs: [String: Set<String>] = [:]
        var outputs: [String: [String]] = [:]
        var types: [String: Character?] = [:]

        for entry in try input.wholeInput.lines {
            let segments = entry.split(separator: " -> ")
            guard segments.count == 2, var name = segments.first.map(String.init), let output = segments.last?.split(separator: ", ").map(String.init) else {
                throw ParseError()
            }
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

        modules = types.map { name, prefix in
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
        for module in modules.values {
            module.reset()
        }
    }

    func pushButton(evaluate: ((Instruction) -> Void)? = nil) {
        var instructions = [Instruction(sender: "button", pulse: .low, destination: "broadcaster")]
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

    func isConjunction(_ module: String) -> Bool {
        modules[module] is Conjunction
    }

    func isInverter(_ module: String) -> Bool {
        isConjunction(module) && inputs(of: module).count == 1
    }

    struct Instruction {
        let sender: String
        let pulse: Pulse
        let destination: String
    }

    enum Pulse {
        case high, low
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
        func reset() {}
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

        override func reset() {
            isOn = false
        }
    }

    private final class Conjunction: Module {
        private var memory: [String: Pulse] = [:]

        override func handle(pulse: Pulse, from module: String) -> Pulse {
            memory[module] = pulse
            return inputs.allSatisfy { memory[$0, default: .low] == .high } ? .low : .high
        }

        override func reset() {
            memory = [:]
        }
    }

    private final class Broadcaster: Module {
        override func handle(pulse: Pulse, from module: String) -> Pulse {
            pulse
        }
    }
}
