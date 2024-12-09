import Utils

public final class AoC_2024_Day9 {
    let disk: [DiskElement]

    public init(_ input: Input) throws {
        let diskMap = try input.wholeInput
        var disk: [DiskElement] = []
        var id = 0
        for (index, value) in diskMap.compactMap(\.wholeNumberValue).enumerated() {
            let isFileBlock = index.isMultiple(of: 2)
            disk.append(DiskElement(count: value, type: isFileBlock ? .fileBlock(id: id) : .emptySpace))
            if isFileBlock { id += 1 }
        }
        self.disk = disk
    }

    public func solvePart1() -> Int {
        var disk = disk
        while var emptyIndex = disk.firstIndex(where: \.isEmpty) {
            while disk[emptyIndex].count > 0, let fileIndex = disk.lastIndex(where: \.isFile) {
                let size = min(disk[emptyIndex].count, disk[fileIndex].count)
                disk[fileIndex].count -= size
                disk[emptyIndex].count -= size
                disk.insert(DiskElement(count: size, type: disk[fileIndex].type), at: emptyIndex)
                emptyIndex += 1
            }
        }
        return checksum(of: disk)
    }

    public func solvePart2() -> Int {
        var disk = disk
        var processed: Set<Int> = []
        files: while let fileIndex = disk.lastIndex(where: { $0.isFile && !processed.contains($0.type.id!) }) {
            let file = disk[fileIndex]
            if let emptyIndex = disk.firstIndex(where: { $0.isEmpty && $0.count >= disk[fileIndex].count }), emptyIndex < fileIndex {
                let size = file.count
                disk[fileIndex] = DiskElement(count: size, type: .emptySpace)
                disk[emptyIndex].count -= size
                disk.insert(DiskElement(count: size, type: file.type), at: emptyIndex)
            }
            processed.insert(file.type.id!)
        }
        return checksum(of: disk)
    }

    private func checksum(of disk: [DiskElement]) -> Int {
        var checksum = 0
        var offset = 0
        for element in disk {
            switch element.type {
                case .fileBlock(let id):
                    for _ in 0 ..< element.count {
                        checksum += id * offset
                        offset += 1
                    }
                case .emptySpace:
                    offset += element.count
            }
        }
        return checksum
    }
}

struct DiskElement: CustomStringConvertible {
    var count: Int
    let type: DiskElementType

    enum DiskElementType: CustomStringConvertible {
        case emptySpace
        case fileBlock(id: Int)

        var isEmpty: Bool {
            switch self {
                case .emptySpace: true
                case .fileBlock: false
            }
        }

        var id: Int? {
            switch self {
                case .emptySpace: nil
                case .fileBlock(let id): id
            }
        }

        var description: String {
            switch self {
                case .emptySpace: "."
                case .fileBlock(let id): String(id)
            }
        }
    }

    var isEmpty: Bool {
        type.isEmpty && count > 0
    }

    var isFile: Bool {
        !type.isEmpty && count > 0
    }

    var description: String {
        String(repeating: type.description, count: count)
    }
}

extension [DiskElement] {
    var description: String {
        map(\.description).joined(separator: "")
    }
}
