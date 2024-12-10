import Utils

public final class AoC_2024_Day9 {
    private let disk: [ElementType]

    public init(_ input: Input) throws {
        disk = try input.wholeInput.lazy.compactMap(\.wholeNumberValue).enumerated().flatMap { offset, element in
            Array(repeating: offset.isMultiple(of: 2) ? .file(id: (offset + 1) / 2) : .freeSpace, count: element)
        }
    }

    public func solvePart1() -> Int {
        var disk = disk
        var lastFileIndex = disk.endIndex
        var lastSpaceIndex = disk.startIndex
        while let firstSpace = (lastSpaceIndex ..< disk.endIndex).first(where: { disk[$0].id == nil }),
              let lastFile = (disk.startIndex ..< lastFileIndex).lazy.last(where: { disk[$0].id != nil }),
              firstSpace < lastFile {
            disk.swapAt(lastFile, firstSpace)
            lastFileIndex = lastFile
            lastSpaceIndex = firstSpace
        }
        return checksum(of: disk)
    }

    public func solvePart2() -> Int {
        var disk = disk
        var lastFileIndex = disk.endIndex
        var lastSpaceIndex = disk.startIndex
        var lastFileId: Int = .max
        while let fileIndex = (disk.startIndex ..< lastFileIndex).lazy.last(where: { disk[$0].id.map { $0 < lastFileId } ?? false }),
              let id = disk[fileIndex].id {
            let fileSize = (disk.startIndex ... fileIndex).reversed().prefix(while: { disk[$0].id == id }).count
            if let spaceIndex = findNextSpace(in: disk, atLeast: fileSize), spaceIndex < fileIndex {
                for offset in 0 ..< fileSize {
                    lastFileIndex = fileIndex - offset
                    lastSpaceIndex = spaceIndex + offset
                    disk.swapAt(lastFileIndex, lastSpaceIndex)
                }
            }
            lastFileId = id
        }
        return checksum(of: disk)
    }

    private func checksum(of disk: [ElementType]) -> Int {
        disk.enumerated().sum { offset, element in
            switch element {
                case .freeSpace: 0
                case .file(let id): id * offset
            }
        }
    }

    private func findNextSpace(in disk: [ElementType], atLeast minimumSize: Int) -> Int? {
        for startIndex in disk.indices where disk[startIndex].id == nil {
            let size = (startIndex ..< disk.endIndex).prefix(while: { disk[$0].id == nil }).count
            if size >= minimumSize {
                return startIndex
            }
        }
        return nil
    }
}

private enum ElementType {
    case freeSpace
    case file(id: Int)

    var id: Int? {
        switch self {
            case .file(let id): id
            case .freeSpace: nil
        }
    }
}

extension [ElementType] {
    var description: String {
        map { $0.id.map(String.init) ?? "nil" }.joined(separator: ", ")
    }
}
