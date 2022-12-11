import RegexBuilder
import Utils

public final class AoC_2022_Day11 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> Int {
        try run(rounds: 20) { Int($0 / 3) }
    }

    public func solvePart2() throws -> Int {
        try run(rounds: 10_000) { $0 }
    }

    private func run(rounds: Int, rule: (Int) -> Int) throws -> Int {
        var monkeys = try input.wholeInput.paragraphs.map { $0.joined(separator: "\n") }.map(parse)
        let commonDivisor = monkeys.map(\.divisor).product()
        for _ in 1...rounds {
            for index in monkeys.indices {
                let monkey = monkeys[index]
                for item in monkey.items {
                    let worryLevel = rule(monkey.operation(item)) % commonDivisor
                    let recipient = monkey.throwToMonkey(worryLevel)
                    monkeys[recipient].items.append(worryLevel)
                }
                monkeys[index].numberOfInspectedItems += monkey.items.count
                monkeys[index].items.removeAll()
            }
        }
        return monkeys.map(\.numberOfInspectedItems).max(count: 2).product()
    }

    private func parse(string: String) throws -> Monkey {
        let regex = #/
        Monkey\ (?<monkey>\d+):\
        \ \ Starting\ items:\ (?<items>.*)\
        \ \ Operation:\ new\ =\ (?<lhs>.*)\ (?<operation>.)\ (?<rhs>.*)\
        \ \ Test:\ divisible\ by\ (?<divisor>\d+)\
        \ \ \ \ If\ true:\ throw\ to\ monkey\ (?<true>\d+)\
        \ \ \ \ If\ false:\ throw\ to\ monkey\ (?<false>\d+)
        /#
        guard let output = string.wholeMatch(of: regex)?.output,
              let operation = Operation(output.operation),
              let index = Int(output.monkey),
              let divisor = Int(output.divisor),
              let trueMonkey = Int(output.true),
              let falseMonkey = Int(output.false) else {
            throw ParseError()
        }
        return Monkey(index: index,
                      items: output.items.split(separator: ", ").map(String.init).compactMap(Int.init),
                      divisor: divisor,
                      operation: {
                        operation.perform(Int(output.lhs) ?? $0,
                                          Int(output.rhs) ?? $0)
                      },
                      throwToMonkey: {
                        $0.isMultiple(of: divisor) ? trueMonkey : falseMonkey
                      })
    }
}

private struct ParseError: Error {}

private struct Monkey {
    let index: Int
    var items: [Int]
    var numberOfInspectedItems: Int = 0
    var divisor: Int
    let operation: (Int) -> Int
    let throwToMonkey: (Int) -> Int
}

private struct Operation {
    let sign: String
    let perform: (Int, Int) -> Int

    static let addition = Operation(sign: "+") { $0 + $1 }
    static let multiplication = Operation(sign: "*") { $0 * $1 }
}

private extension Operation {
    init?(_ rawValue: some StringProtocol) {
        switch rawValue {
        case "+":
            self = .addition
        case "*":
            self = .multiplication
        default:
            return nil
        }
    }

}
