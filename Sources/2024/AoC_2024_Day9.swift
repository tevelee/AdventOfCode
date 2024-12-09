import Utils

public final class AoC_2024_Day9 {
    private let diskMap: DiskMap

    public init(_ input: Input) throws {
        diskMap = try input.wholeInput.lazy.compactMap(\.wholeNumberValue).enumerated().map { offset, element in
            DiskBlock(size: element, type: offset.isMultiple(of: 2) ? .file(id: (offset + 1) / 2) : .freeSpace)
        }
    }

    public func solvePart1() -> Int {
        var diskMap = diskMap
        while let indexOfFreeSpaceBlock = diskMap.firstIndex(where: { $0.size > 0 && $0.type.isFreeSpace }) {
            var remainingSpace = diskMap[indexOfFreeSpaceBlock].size
            if remainingSpace > 0, let indexOfFileBlock = diskMap.lastIndex(where: { $0.size > 0 && !$0.type.isFreeSpace }), case .file(let id) = diskMap[indexOfFileBlock].type {
                let fileBlockSize = diskMap[indexOfFileBlock].size
                let diff = reduceSize(of: indexOfFileBlock, in: &diskMap, by: remainingSpace)
                remainingSpace -= diff
                reduceSize(of: indexOfFreeSpaceBlock, in: &diskMap, by: fileBlockSize)
                diskMap.insert(DiskBlock(size: diff, type: .file(id: id)), at: indexOfFreeSpaceBlock)
            }
        }
        return checksum(of: diskMap)
    }

    @discardableResult
    private func reduceSize(of index: Int, in array: inout [DiskBlock], by amount: Int) -> Int {
        let diff = min(array[index].size, amount)
        if diff == 0 {
            array.remove(at: index)
        } else {
            array[index].size -= diff
        }
        return diff
    }

    public func solvePart2() -> Int {
        var diskMap = diskMap
        var lastProcessedId: Int = .max
        while lastProcessedId > 0 {
            let fileBlock = stride(from: 0, to: diskMap.endIndex, by: 2).lazy
                .reversed()
                .compactMap { index in diskMap[index].type.id.map { (index: index, size: diskMap[index].size, id: $0) } }
                .first { $0.id < lastProcessedId }
            guard let fileBlock else {
                continue
            }
            if let indexOfFreeSpaceBlock = stride(from: 1, to: fileBlock.index, by: 2).first(where: { diskMap[$0].size >= fileBlock.size }) {
                let freeSpace = diskMap[indexOfFreeSpaceBlock].size
                let before = diskMap[safe: fileBlock.index - 1]?.size ?? 0
                let after = diskMap[safe: fileBlock.index + 1]?.size ?? 0
                // join spaces
                diskMap.replaceSubrange((fileBlock.index - 1 ... fileBlock.index + 1).clamped(to: 0 ... diskMap.endIndex - 1), with: [
                    DiskBlock(size: before + fileBlock.size + after, type: .freeSpace)
                ])
                // replace big space with (zero space + file + remaining space) to retain alternation
                diskMap.replaceSubrange(indexOfFreeSpaceBlock ... indexOfFreeSpaceBlock, with: [
                    DiskBlock(size: 0, type: .freeSpace),
                    DiskBlock(size: fileBlock.size, type: .file(id: fileBlock.id)),
                    DiskBlock(size: freeSpace - fileBlock.size, type: .freeSpace)
                ])
            }
            lastProcessedId = fileBlock.id
        }
        return checksum(of: diskMap)
    }

    private func checksum(of diskMap: consuming DiskMap) -> Int {
        var index = 0
        return diskMap.sum { block in
            let indexBefore = index
            index += block.size
            return switch block.type {
            case .freeSpace: 0
            case .file(let id): id * (sumOfIncrements(until: index) - sumOfIncrements(until: indexBefore)) }
        }
    }

    private func sumOfIncrements(until target: Int) -> Int {
        (target - 1) * target / 2
    }
}

private typealias DiskMap = [DiskBlock]

extension DiskMap {
    var description: String {
        map(\.description).joined()
    }
}

private struct DiskBlock: CustomStringConvertible {
    var size: Int
    let type: DiskBlockType

    var description: String {
        String(repeating: type.description, count: size)
    }

    enum DiskBlockType: CustomStringConvertible {
        case freeSpace
        case file(id: Int)

        var description: String {
            switch self {
            case .freeSpace: "."
            case .file(let id): "\(id)"
            }
        }

        var isFreeSpace: Bool {
            id == nil
        }

        var id: Int? {
            switch self {
            case .freeSpace: nil
            case .file(let id): id
            }
        }
    }
}
