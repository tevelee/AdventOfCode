import Foundation
import ArgumentParser
import SwiftSoup

@MainActor let urlSession = URLSession.shared
@MainActor let fileManager = FileManager.default

@MainActor
@main
struct FetchEvents: AsyncParsableCommand {
    @Argument(help: "Path")
    var path: String

    @Option(name: .long)
    var start = 2015

    @Option(name: .long)
    var end = 2024

    @Option(name: .long)
    var session: String?

    @Flag
    var downloadInputs: Bool = false

    struct ID {
        let year: Int
        let day: Int

        var moduleName: String {
            "AoC_\(year)"
        }

        var className: String {
            "\(moduleName)_Day\(day)"
        }
    }

    private enum FetchError: Error {
        case invalidURL
        case invalidData
    }

    mutating func run() async throws {
        authenticateSession()
        for year in start...end {
            for day in 1...25 {
                print("\(year) day \(day)")
                let id = ID(year: year, day: day)
                try await bootstrap(for: id)
                let html = try await fetchTask(for: id)
                guard let converted = try convertTaskToMarkdown(html) else { break }
                try writeTask(for: id, part1: converted.part1, part2: converted.part2)
                if downloadInputs {
                    try await downloadInput(for: id)
                }
            }
        }
        print("Finished")
    }

    func authenticateSession() {
        urlSession.configuration.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.1 Safari/605.1.15"
        ]
        if let session, let cookie = HTTPCookie(properties: [
            .name: "session",
            .value: session,
            .domain: ".adventofcode.com",
            .path: "/"
        ]) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
    }

    private func fetchTask(for id: ID) async throws -> String {
        guard let url = URL(string: "https://adventofcode.com/\(id.year)/day/\(id.day)") else {
            throw FetchError.invalidURL
        }
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        guard let string = String(data: data, encoding: .utf8) else {
            throw FetchError.invalidData
        }
        return string
    }

    private func bootstrap(for id: ID) async throws {
        let files = [
            URL(filePath: path).appending(components: "Sources", String(id.year), "\(id.className).swift"): sourceFileTemplate(for: id),
            URL(filePath: path).appending(components: "Tests", String(id.year), "Resources", "\(id.year)_day\(id.day).txt"): "",
            URL(filePath: path).appending(components: "Tests", String(id.year), "Day\(id.day).swift"): testFileTemplate(for: id),
            URL(filePath: path).appending(components: "Tests", String(id.year), "Tests.swift"): xctestFileTemplate(for: id),
            URL(filePath: path).appending(components: "Tests", String(id.year), "Puzzle.swift"): puzzleFileTemplate(),
        ]
        for (file, template) in files {
            if fileManager.fileExists(atPath: file.relativePath) {
                continue
            }
            try fileManager.createDirectory(at: file.deletingLastPathComponent(), withIntermediateDirectories: true)
            try Data(template.utf8).write(to: file)
        }
    }

    private func downloadInput(for id: ID) async throws {
        let fileURL = URL(filePath: path).appending(components: "Tests", String(id.year), "Resources", "\(id.year)_day\(id.day).txt")
        let fileSize = (try? fileManager.attributesOfItem(atPath: fileURL.path)[.size] as? Double) ?? 0
        if fileSize > 0 {
            return
        }
        guard let url = URL(string: "https://adventofcode.com/\(id.year)/day/\(id.day)/input") else {
            throw FetchError.invalidURL
        }
        let request = URLRequest(url: url)
        let (data, _) = try await urlSession.data(for: request)
        try data.write(to: fileURL)
    }

    private func writeTask(for id: ID, part1: String, part2: String?) throws {
        let directoryURL = URL(filePath: path).appending(components: "Sources", String(id.year), "Tasks")
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
        try part1.write(
            to: directoryURL.appending(component: "\(id.className)_part1.md"),
            atomically: true,
            encoding: .utf8
        )
        try part2?.write(
            to: directoryURL.appending(component: "\(id.className)_part2.md"),
            atomically: true,
            encoding: .utf8
        )
    }

    private func convertTaskToMarkdown(_ html: String) throws -> (part1: String, part2: String?)? {
        guard let articles = try? SwiftSoup.parse(html).select("main article").array(),
              let part1 = articles.first else {
            return nil
        }
        return try (process(article: part1), articles.dropFirst().first.map(process))
    }

    private func process(article: Element) throws -> String {
        try article.getChildNodes().map(convert).joined(separator: "\n")
    }

    private func convert(node: Node) throws -> String {
        if let element = node as? TextNode {
            return element.text()
        }
        guard let element = node as? Element else {
            return ""
        }
        let text = try element.text(trimAndNormaliseWhitespace: false)
        switch element.tagName() {
        case "h1":
            return "# \(text)"
        case "h2":
            return "## \(text)"
        case "h3":
            return "### \(text)"
        case "h4":
            return "#### \(text)"
        case "h5":
            return "##### \(text)"
        case "h6":
            return "##### \(text)"
        case "span" where element.hasAttr("title"):
            return try "\(text)<!--- \(element.attr("title")) -->"
        case "p", "div", "span":
            return try element.getChildNodes().map(convert).joined()
        case "li":
            let body = try element.getChildNodes().map(convert).joined()
            if element.children().first()?.tagName() == "pre" {
                return body
            } else {
                return "- " + body
            }
        case "em" where element.hasClass("star"):
            return "***\(text)***"
        case "em":
            return "**\(text)**"
        case "s":
            return "~\(text)~"
        case "a":
            return try "[\(text)](\(element.attr("href")))"
        case "code":
            return "`\(text)`"
        case "pre":
            let prefix = text.hasPrefix("\n") ? "" : "\n"
            let suffix = text.hasSuffix("\n") ? "" : "\n"
            return "\n```\(prefix)\(text)\(suffix)```\n"
        case "hr":
            return "---"
        case "br":
            return "\n"
        case "ul":
            return try element.getChildNodes().map(convert).joined(separator: "\n")
        default:
            return text
        }
    }

    private func sourceFileTemplate(for id: ID) -> String {
        #"""
        import Utils
        
        public final class \#(id.className) {
            let input: Input
        
            public init(_ input: Input) {
                self.input = input
            }
        
            public func solvePart1() async throws -> Int {
                0
            }
        
            public func solvePart2() async throws -> Int {
                0
            }
        }
        
        """#
    }

    private func testFileTemplate(for id: ID) -> String {
        #"""
        import \#(id.moduleName)
        import Testing
        
        private typealias CurrentPuzzle = \#(id.className)
        extension CurrentPuzzle: Puzzle {}
        
        private struct Day\#(id.day) {
            @Test
            func part1_intro() async throws {
                let problem = CurrentPuzzle("""
                """)
                try await #expect(problem.solvePart1() == 0)
            }
        
            @Test
            func part2_intro() async throws {
                let problem = CurrentPuzzle("""
                """)
                try await #expect(problem.solvePart2() == 0)
            }
        
            @Test(.tags(.live))
            func live() async throws {
                let problem = try await CurrentPuzzle()
                try await #expect(problem.solvePart1() == 0)
                try await #expect(problem.solvePart2() == 0)
            }
        }
        
        """#
    }

    private func xctestFileTemplate(for id: ID) -> String {
        #"""
        import \#(id.moduleName)
        import Foundation
        import Testing
        import XCTest
        
        final class \#(id.moduleName)_Tests: XCTestCase {
        #if swift(<6.0)
            func testAll() async {
                await XCTestScaffold.runAllTests(hostedBy: self)
            }
        #endif
        }
        
        extension Tag {
            @Tag static var live: Tag
        }
        
        """#
    }

    private func puzzleFileTemplate() -> String {
        #"""
        import Foundation
        import Testing
        import Utils
        
        protocol Puzzle {
            init(_ input: Input) async throws
            static var year: Int { get }
            static var day: Int { get }
        }
        
        extension Puzzle {
            private static var className: String {
                String(reflecting: Self.self)
            }
        
            @inlinable static var day: Int {
                className.integers.last!
            }
        
            @inlinable static var year: Int {
                className.integers.first!
            }
        }
        
        extension Puzzle {
            init() async throws {
                try await self.init(file("\(Self.year)_day\(Self.day)"))
            }
        }
        
        func file(_ fileName: String, fileExtension: String = "txt") throws -> Input {
            let url = try #require(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
            return .contentsOfFile(url)
        }
        
        """#
    }
}
