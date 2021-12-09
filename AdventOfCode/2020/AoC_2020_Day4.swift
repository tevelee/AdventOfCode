import Foundation

public final class AoC_2020_Day4 {
    let input: String

    public convenience init(_ inputFileURL: URL) throws {
        self.init(try String(contentsOf: inputFileURL))
    }

    public init(_ input: String) {
        self.input = input.appending("\n")
    }

    public func solvePart1() -> Int {
        solve(validate: { ["byr", "iyr", "eyr", "hcl", "ecl", "pid", "hgt"].allSatisfy($0.keys.contains) })
    }

    public func solvePart2() -> Int {
        solve(validate: validate)
    }

    public func solve(validate: @escaping ([String: String]) -> Bool) -> Int {
        var count = 0
        var passport: [String: String] = [:]
        for line in input.lines(includeEmptyLines: true) {
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

    private func validate(_ passport: [String: String]) -> Bool {
        guard ["byr", "iyr", "eyr", "hcl", "ecl", "pid", "hgt"].allSatisfy(passport.keys.contains) else { return false }
        if passport.count == 8, !passport.keys.contains("cid") { return false }
        return passport.allSatisfy(validate)
    }

    private func validate(field: String, value: String) -> Bool {
        switch field {
            case "byr":
                return value.isYear(between: 1920...2002)
            case "iyr":
                return value.isYear(between: 2010...2020)
            case "eyr":
                return value.isYear(between: 2020...2030)
            case "hcl":
                return value.count == 7 && value.hasPrefix("#") && value.dropFirst().allSatisfy("abcdef0123456789".contains)
            case "ecl":
                return value.count == 3 && ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(value)
            case "pid":
                return value.count == 9 && value.allSatisfy(\.isNumber)
            case "hgt":
                if value.hasSuffix("cm"), let index = value.firstIndex(of: "c"), let number = Int(value[..<index]) {
                    return (150...193).contains(number)
                }
                if value.hasSuffix("in"), let index = value.firstIndex(of: "i"), let number = Int(value[..<index]) {
                    return (59...76).contains(number)
                }
                return false
            case "cid":
                return true
            default:
                return false
        }
    }
}

private extension String {
    func isYear(between range: ClosedRange<Int>) -> Bool {
        guard count == 4, let int = Int(self) else { return false }
        return range.contains(int)
    }
}
