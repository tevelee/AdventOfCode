import Utils

public final class AoC_2022_Day17 {
    private let rocks: [Rock] = [
        """
        ####
        """,
        """
        .#.
        ###
        .#.
        """,
        """
        ..#
        ..#
        ###
        """,
        """
        #
        #
        #
        #
        """,
        """
        ##
        ##
        """,
    ]
    private var instructions: [Character]

    public init(_ input: Input) throws {
        instructions = try Array(input.wholeInput)
        if let index = instructions.lastIndex(of: "\n") {
            instructions.remove(at: index)
        }
    }

    public func solvePart1() -> Int {
        solveManually(n: 2022)
    }

    public func solvePart2() -> Int {
        solveByDetectingCycle(n: 1_000_000_000_000)
    }

    private func solveManually(n: Int) -> Int {
        var chamber = Chamber(poolOfInstructions: instructions, poolOfRocks: rocks)
        repeat {
            chamber.advance()
        } while chamber.numberOfRocksPlaced < n
        return chamber.height
    }

    private func solveByDetectingCycle(n: Int) -> Int {
        if let cycle = detectCycle() {
            let (quotient, remainder) = n.quotientAndRemainder(dividingBy: cycle.rocksPlaced)
            let heightAtTheSameNumberOfRocksPlaced = cycle.states.first  { $0.rocksPlaced == remainder }!.height
            return heightAtTheSameNumberOfRocksPlaced + cycle.height * quotient
        }
        return 0
    }

    private struct Cycle: Hashable {
        let rocksPlaced: Int
        let height: Int
        let offset: Int
        let states: [State]
    }

    private struct State: Hashable {
        let instructionIndex: Int
        let rockIndex: Int
        let rocksPlaced: Int
        let height: Int
    }

    private func detectCycle() -> Cycle? {
        var states: [State] = []
        var chamber = Chamber(poolOfInstructions: instructions, poolOfRocks: rocks)
        while true {
            chamber.advance()
            let state = State(instructionIndex: chamber.instructionIndex,
                              rockIndex: chamber.rockIndex,
                              rocksPlaced: chamber.numberOfRocksPlaced,
                              height: chamber.height)
            for previous in states where previous.instructionIndex == state.instructionIndex && previous.rockIndex == state.rockIndex {
                let diff = state.height - previous.height
                let rocksPlaced = state.rocksPlaced - previous.rocksPlaced
                if state.height < diff * 2 || state.rocksPlaced < rocksPlaced * 2 { continue }
                for offset in 0...diff where chamber.height > offset + diff + diff {
                    let isCycle = chamber.stack[offset..<(offset + diff)] == chamber.stack[(offset + diff)..<(offset + diff + diff)]
                    if isCycle {
                        return Cycle(rocksPlaced: rocksPlaced, height: diff, offset: offset, states: states)
                    }
                }
            }
            states.append(state)
        }
    }
}

private struct Chamber {
    private let poolOfInstructions: [Character]
    private let poolOfRocks: [Rock]

    fileprivate var rockIndex: Int = 0
    fileprivate var instructionIndex: Int = 0

    fileprivate var stack: [UInt8] = []
    private var rock: (shape: Rock, y: Int)
    var numberOfRocksPlaced = 0

    init(poolOfInstructions: [Character], poolOfRocks: [Rock]) {
        self.poolOfInstructions = poolOfInstructions
        self.poolOfRocks = poolOfRocks
        rock = (poolOfRocks[rockIndex] << 2, 3)
    }

    var height: Int {
        stack.endIndex
    }

    mutating func advance() {
        //visualize()
        let instruction = poolOfInstructions[instructionIndex]
        perform(instruction)
        if isRockStopped() {
            embedRock()
            nextRock()
        } else {
            advanceRock()
        }
        nextInstruction()
    }

    @discardableResult
    private mutating func perform(_ instruction: Character) -> Bool {
        if instruction == "<", rock.shape.stack.contains(where: { $0 & 1 > 0 }) {
            return false
        }
        if instruction == ">", rock.shape.stack.contains(where: { $0 & 1 << 6 > 0 }) {
            return false
        }
        var movedRock = rock.shape

        switch instruction {
        case "<":
            movedRock >>= 1
        case ">":
            movedRock <<= 1
        default:
            fatalError()
        }

        for y in rock.y ..< rock.y + rock.shape.height where y < stack.endIndex && stack[y] & movedRock.stack[y - rock.y] > 0 {
            return false
        }

        rock.shape = movedRock
        return true
    }

    private mutating func advanceRock() {
        rock.y -= 1
    }

    private mutating func embedRock() {
        for y in rock.y ..< rock.y + rock.shape.height {
            let rockLine = rock.shape.stack[y - rock.y]
            if y < stack.endIndex {
                stack[y] |= rockLine
            } else {
                stack.append(rockLine)
            }
        }
        numberOfRocksPlaced += 1
    }

    private func isRockStopped() -> Bool {
        if stack.isEmpty {
            return rock.y == 0
        }
        if rock.y > stack.endIndex {
            return false
        }
        for y in rock.y - 1 ..< min(stack.endIndex, rock.y - 1 + rock.shape.height) where stack[y] & rock.shape.stack[y - rock.y + 1] > 0 {
            return true
        }
        return false
    }

    private mutating func nextRock() {
        rockIndex += 1
        if rockIndex == poolOfRocks.endIndex {
            rockIndex = poolOfRocks.startIndex
        }
        self.rock = (poolOfRocks[rockIndex] << 2, stack.endIndex + 3)
    }

    private mutating func nextInstruction() {
        instructionIndex += 1
        if instructionIndex == poolOfInstructions.endIndex {
            instructionIndex = poolOfInstructions.startIndex
        }
    }

    func visualize() {
        for y in (0 ... (height + 5)).reversed() {
            var line: [Character] = Array(repeating: ".", count: 7)
            if let chamberValue = stack[safe: y] {
                let chamberLine = stringify(binary: chamberValue)
                for characterIndex in 0..<7 where chamberLine[characterIndex] == "1" {
                    line[characterIndex] = "#"
                }
            }
            if let rockValue = rock.shape.stack[safe: y - rock.y] {
                let rockLine = stringify(binary: rockValue)
                for characterIndex in 0..<7 where rockLine[characterIndex] == "1" {
                    line[characterIndex] = "@"
                }
            }
            print("|\(String(line))|")
        }
        print("+\(String(repeating: "-", count: 7))+")
    }
}

private struct Rock: ExpressibleByStringLiteral {
    let width: Int
    let height: Int
    var stack: [UInt8]

    init(stringLiteral value: String) {
        height = value.lines.count
        width = value.lines.first?.count ?? 0
        stack = value.lines.reversed().map { String($0.reversed()) }.map(binary)
    }

    func apply(_ block: (inout Rock) -> Void) -> Rock {
        var copy = self
        block(&copy)
        return copy
    }
}

private func <<(rock: Rock, value: Int) -> Rock {
    rock.apply { $0 <<= value }
}

private func <<=(rock: inout Rock, value: Int) {
    for index in rock.stack.indices {
        rock.stack[index] <<= value
    }
}

private func >>(rock: Rock, value: Int) -> Rock {
    rock.apply { $0 >>= value }
}

private func >>=(rock: inout Rock, value: Int) {
    for index in rock.stack.indices {
        rock.stack[index] >>= value
    }
}

private func binary(from string: String) -> UInt8 {
    let integers = Array(string).map { $0 == "#" }
    return binary(from: integers)
}

private func binary(from integers: [Bool]) -> UInt8 {
    integers.reduce(0) { result, item in
        result * 2 + (item ? 1 : 0)
    }
}

private func stringify(binary: UInt8, length: Int = 7) -> String {
    var result = ""
    var value = binary
    while value > 0 {
        if value.isMultiple(of: 2) {
            result.append("0")
        } else {
            result.append("1")
            value -= 1
        }
        value /= 2
    }
    return String(result) + Array(repeating: "0", count: max(0, length - result.count))
}
