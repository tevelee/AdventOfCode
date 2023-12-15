import Collections
import Utils

final class AoC_2023_Day15 {
    private let values: AnyAsyncSequence<[Character]>

    init(_ input: Input) {
        values = input.characters.filter { $0 != "\n" }.split(by: ",")

    }

    func solvePart1() async throws -> Int {
        try await values.sum(of: hash)
    }

    func solvePart2() async throws -> Int {
        var boxes: [Int: OrderedDictionary<String, Int>] = [:]
        for try await value in values {
            if let index = value.firstIndex(of: "-") {
                let name = String(value[..<index])
                boxes[hash(for: name), default: [:]][name] = nil
            } else if let index = value.firstIndex(of: "="), let focalLength = value[index + 1].wholeNumberValue {
                let name = String(value[..<index])
                boxes[hash(for: name), default: [:]][name] = focalLength
            }
        }
        return boxes.sum { boxIndex, lenses in
            lenses.values.enumerated().sum { offset, focalLength in
                (boxIndex + 1) * (offset + 1) * focalLength
            }
        }
    }

    private func hash(for characters: some Sequence<Character>) -> Int {
        characters.compactMap(\.asciiValue).reduce(0) { result, character in
            (result + Int(character)) * 17 % 256
        }
    }
}
