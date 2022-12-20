import Utils

public final class AoC_2022_Day20 {
    private let numbers: [Int]

    public init(_ input: Input) throws {
        numbers = try input.wholeInput.lines.compactMap(Int.init)
    }

    public func solvePart1() -> Int {
        let mixed = mix(numbers: numbers)
        return groveCoordinate(from: mixed)
    }

    public func solvePart2() -> Int {
        let mixed = mix(numbers: numbers.map { $0 * 811589153 }, times: 10)
        return groveCoordinate(from: mixed)
    }


    private func mix(numbers: [Int], times: Int = 1) -> [Int] {
        var mixed = numbers.enumerated().map(Number.init)
        let originalOrder = mixed
        for _ in 1...times {
            for entry in originalOrder {
                let oldIndex = mixed.firstIndex(where: { $0.originalIndex == entry.originalIndex })!
                mixed.moveElement(from: oldIndex, by: entry.value)
            }
        }
        return mixed.map(\.value)
    }

    private func groveCoordinate(from numbers: [Int]) -> Int {
        let indexOfZero = numbers.firstIndex(of: 0)!
        return [1000, 2000, 3000].sum { offset in
            let newIndex = (indexOfZero + offset) % numbers.endIndex
            return numbers[newIndex]
        }
    }
}

private struct Number: Hashable {
    let originalIndex: Int
    let value: Int
}

private extension RangeReplaceableCollection where Index == Int {
    mutating func moveElement(from oldIndex: Int, by diff: Int) {
        let element = remove(at: oldIndex)
        let newIndex = nonNegativeModulo(of: oldIndex + diff, by: endIndex)
        insert(element, at: newIndex)
    }
}

private func nonNegativeModulo(of lhs: Int, by rhs: Int) -> Int {
    let result = lhs % rhs
    return result >= 0 ? result : result + rhs
}
