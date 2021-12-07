import Foundation
import Parsing

public final class AoC_2020_Day4 {
    let inputFileURL: URL

    public init(_ inputFileURL: URL) {
        self.inputFileURL = inputFileURL
    }

    public func solvePart1() async throws -> Int {
        try await solve(validate: { ["byr", "iyr", "eyr", "hcl", "ecl", "pid", "hgt"].allSatisfy($0.keys.contains) })
    }

    public func solvePart2() async throws -> Int {
        try await solve(validate: validate)
    }

    public func solve(validate: @escaping ([String: String]) -> Bool) async throws -> Int {
        var count = 0
        var passport: [String: String] = [:]
        for line in try String(contentsOf: inputFileURL).lines(includeEmptyLines: true) {
            if line.isEmpty {
                if validate(passport) {
                    count += 1
                }
                passport = [:]
                continue
            }
            let components = line.split(separator: " ").map { $0.split(separator: ":").map(String.init) }.map { (key: $0[0], value: $0[1]) }
            for (key, value) in components {
                passport[key] = value
            }
        }
        return count
    }

    func validate(_ passport: [String: String]) -> Bool {
        let requiredFields = ["byr", "iyr", "eyr", "hcl", "ecl", "pid", "hgt"]
        guard (passport.keys.count == 7 && requiredFields.allSatisfy(passport.keys.contains)) ||
                (passport.keys.count == 8 && passport.keys.contains("cid")) else { return false }

        let string = passport.map { "\($0.key):\($0.value)" }.joined(separator: " ")[...]
        let hex = Prefix(2).pipe(UInt8.parser(of: Substring.self, isSigned: false, radix: 16).skip(End()))

        let byr = StartsWith("byr").skip(":").skip(Prefix(4).pipe(Int.parser().filter((1920...2002).contains))).eraseToAnyParser().map { _ in "byr" }
        let iyr = StartsWith("iyr").skip(":").skip(Prefix(4).pipe(Int.parser().filter((2010...2020).contains))).eraseToAnyParser().map { _ in "iyr" }
        let eyr = StartsWith("eyr").skip(":").skip(Prefix(4).pipe(Int.parser().filter((2020...2030).contains))).eraseToAnyParser().map { _ in "eyr" }
        let hcl = StartsWith("hcl").skip(":#").skip(hex).skip(hex).skip(hex).eraseToAnyParser().map { _ in "hcl" }
        let ecl = StartsWith("ecl").skip(":").skip(OneOfMany("amb", "blu", "brn", "gry", "grn", "hzl", "oth")).eraseToAnyParser().map { _ in "ecl" }
        let pid = StartsWith("pid").skip(":").skip(Prefix(9).filter { $0.allSatisfy(\.isNumber) }).eraseToAnyParser().map { _ in "pid" }
        let hgt = StartsWith("hgt").skip(":").skip(Int.parser().skip("cm").filter((150...193).contains).orElse(Int.parser().skip("in").filter((59...76).contains))).eraseToAnyParser().map { _ in "hgt" }
        let cid = StartsWith("cid").skip(":").skip(Int.parser()).eraseToAnyParser().map { _ in "cid" }
        let parser = Many(OneOfMany(byr, iyr, eyr, hcl, ecl, pid, hgt, cid), atLeast: 7, atMost: 8, separator: " ")
        return parser.parse(string) != nil
    }
}
