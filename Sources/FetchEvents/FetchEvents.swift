import Foundation
import ArgumentParser
import SwiftSoup

@main
struct FetchEvents: AsyncParsableCommand {
    @Argument(help: "Path")
    var path: String

    @Option(name: .long)
    var start = 2015

    @Option(name: .long)
    var end = 2022

    @Option(name: .long)
    var session: String?

    mutating func run() async throws {
        let urlSession = URLSession.shared
        let fileManager = FileManager.default
        for year in start...end {
            for day in 1...25 {
                let url = URL(string: "https://adventofcode.com/\(year)/day/\(day)")!
                if let session, let cookie = HTTPCookie(properties: [
                    .name: "session",
                    .value: session,
                    .domain: ".adventofcode.com",
                    .path: "/"
                ]) {
                    HTTPCookieStorage.shared.setCookie(cookie)
                }
                let request = URLRequest(url: url)
                print("Downloading \(year)/\(day)")
                let (data, _) = try await urlSession.data(for: request)
                let html = String(data: data, encoding: .utf8)!
                let directoryURL = URL(filePath: path).appending(components: String(year), "Tasks")
                try fileManager.createDirectory(at: directoryURL,
                                                withIntermediateDirectories: true)
                if let converted = try convertToMarkdown(html) {
                    try converted.part1.write(to: directoryURL.appending(component: "AoC_\(year)_Day\(day)_part1.md"),
                                              atomically: true,
                                              encoding: .utf8)
                    if let part2 = converted.part2 {
                        try part2.write(to: directoryURL.appending(component: "AoC_\(year)_Day\(day)_part2.md"),
                                        atomically: true,
                                        encoding: .utf8)
                    }
                }
            }
        }
        print("Finished")
    }

    private func convertToMarkdown(_ html: String) throws -> (part1: String, part2: String?)? {
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
        let text = try element.text()
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
            return "\n```\n\(text)\n```\n"
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
}
