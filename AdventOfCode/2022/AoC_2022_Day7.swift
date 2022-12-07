import Foundation
import Algorithms

public final class AoC_2022_Day7 {
    let input: Input

    public init(_ input: Input) {
        self.input = input
    }

    public func solvePart1() throws -> Int {
        let commandsAndOutputs = try input.wholeInput.lines
        let folders = try parse(commandsAndOutputs)
        let tree = try buildTree(from: folders)
        return tree.directories
            .filter { $0.size <= 100_000 }
            .map(\.size)
            .sum()
    }

    public func solvePart2() throws -> Int {
        let commandsAndOutputs = try input.wholeInput.lines
        let folders = try parse(commandsAndOutputs)
        let tree = try buildTree(from: folders)
        let fullSize = tree.size
        let targetSize = 40_000_000
        return tree.directories
            .map(\.size)
            .sorted()
            .first { $0 > fullSize - targetSize } ?? fullSize
    }
}

private struct ParseError: Error {}

private func parse(_ lines: some Sequence<String>) throws -> [URL: [String]] {
    var folders: [URL: [String]] = [:]
    var currentCommand: String?
    var pwd = URL(filePath: "~")

    for line in lines {
        if line.hasPrefix("$") {
            currentCommand = line
            if let folderName = try? (/\$ cd (.*)/.firstMatch(in: line)?.output.1).map(String.init) {
                if folderName == ".." {
                    pwd.deleteLastPathComponent()
                } else if folderName == "/" {
                    pwd = URL(filePath: "")
                } else {
                    pwd.append(path: folderName)
                }
            }
        } else if currentCommand == "$ ls" {
            folders[pwd, default: []].append(line)
        } else {
            throw ParseError()
        }
    }

    return folders
}

private func buildTree(root: URL = URL(filePath: "./"), from folders: [URL: [String]]) throws -> FileTree {
    guard let contents = folders[root] else {
        throw ParseError()
    }
    return try .directory(name: root.lastPathComponent, contents: contents.map { content in
        if let folderName = try /dir (.*)/.firstMatch(in: content)?.output.1 {
            return try buildTree(root: root.appending(component: String(folderName)), from: folders)
        } else if let file = try /(?<size>\d+) (?<name>.*)/.firstMatch(in: content)?.output, let size = Int(file.size) {
            return .file(name: String(file.name), size: size)
        } else {
            throw ParseError()
        }
    })
}

private enum FileTree: CustomStringConvertible {
    case file(name: String, size: Int)
    indirect case directory(name: String, contents: [FileTree])

    var name: String {
        switch self {
        case .file(let name, _):
            return name
        case .directory(let name, _):
            return name
        }
    }

    var size: Int {
        switch self {
        case .file(_, let size):
            return size
        case .directory(_, let contents):
            return contents.map(\.size).sum()
        }
    }

    var directories: [FileTree] {
        switch self {
        case .file:
            return []
        case .directory(_, let contents):
            return [self] + contents.flatMap(\.directories)
        }
    }

    var description: String {
        description(currentLevel: 0).joined(separator: "\n")
    }

    private func description(currentLevel: Int, indentation: Int = 2) -> [String] {
        let prefix = String(repeating: " ", count: indentation * currentLevel)
        switch self {
        case let .file(name, size):
            return ["\(prefix)- \(name) (file, size=\(size))"]
        case let .directory(name, contents):
            return ["\(prefix)- \(name) (dir)"] + contents.flatMap {
                $0.description(currentLevel: currentLevel + 1, indentation: indentation)
            }
        }
    }
}
