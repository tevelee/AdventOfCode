import Algorithms
import Utils

final class AoC_2023_Day14 {
    private let items: [[Character]]
    private lazy var height = items.count

    init(_ input: Input) throws {
        items = try Array(input.wholeInput.lines.map(Array.init))
    }
    
    func solvePart1() -> Int {
        calculateLoad(of: tiltNorth(items))
    }

    func solvePart2() -> Int {
        var items = self.items
        var results: [Int] = []
        repeat {
            results.append(calculateLoad(of: items))
            if let sizeOfRepetition = findRepetitionPattern(in: results) {
                return valueOfRepeatingCollection(at: 1_000_000_000, in: results, sizeOfRepeatingSuffix: sizeOfRepetition)
            }
            items = runCycle(items)
        } while true
    }

    private func calculateLoad(of items: [[Character]]) -> Int {
        items.enumerated().sum { offset, column in
            column.count { $0 == "O" } * (height - offset)
        }
    }

    private func runCycle(_ items: [[Character]]) -> [[Character]] {
        (1...4).reduce(items) { result, _ in
            tiltNorth(result).rotatedClockwise()
        }
    }

    private func tiltNorth(_ items: [[Character]]) -> [[Character]] {
        var items = items
        for x in items[0].indices {
            var lastFixY = -1
            for y in items.indices {
                if items[y][x] == "#" {
                    lastFixY = y
                } else if items[y][x] == "O" {
                    lastFixY += 1
                    let temp = items[y][x]
                    items[y][x] = items[lastFixY][x]
                    items[lastFixY][x] = temp
                }
            }
        }
        return items
    }

    private func findRepetitionPattern(in results: [Int], min: Int = 2) -> Int? {
        for sizeOfRepetition in min ... max(min, results.count / 2) {
            let lastTwoOfSize = results.reversed().chunks(ofCount: sizeOfRepetition).prefix(2).map(Array.init)
            let isRepetition = lastTwoOfSize.count == 2 && lastTwoOfSize[0] == lastTwoOfSize[1]
            if isRepetition {
                return sizeOfRepetition
            }
        }
        return nil
    }

    private func valueOfRepeatingCollection(at projectedIndex: Int, in results: [Int], sizeOfRepeatingSuffix: Int) -> Int {
        let prefixBeforeRepetition = results.count - 2 * sizeOfRepeatingSuffix
        let offsetInRepetition = (projectedIndex - prefixBeforeRepetition) % sizeOfRepeatingSuffix
        return results[prefixBeforeRepetition + offsetInRepetition]
    }
}
