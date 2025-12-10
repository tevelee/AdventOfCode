import Utils
import Graphs

public final class AoC_2025_Day10 {
    private let machines: [Machine]

    public init(_ input: Input) throws {
        machines = try input.wholeInput.lines
            .compactMap { line -> Machine? in
                guard let match = try /\[(?<lights>.*?)\] (?<buttons>.*?) \{(?<joltages>.*?)\}/.wholeMatch(in: line)?.output else { return nil }
                let lights = match.lights.map { $0 == "#" }
                let joltages = match.joltages.integers
                precondition(lights.count == joltages.count)
                let buttons = match.buttons.matches(of: /\(.*?\)/).map { Set($0.output.integers) }
                return Machine(lights: lights, buttons: buttons, joltages: joltages)
            }
    }

    public func solvePart1() -> Int {
        machines.sum { minButtonPressesForLights($0) }
    }

    public func solvePart2() -> Int {
        machines.sum { minButtonPressesForJoltages($0) }
    }

    private func minButtonPressesForLights(_ machine: Machine) -> Int {
        LazyIncidenceGraph { lights in
            machine.buttons.map { button -> Machine.Lights in
                var next = lights
                for index in button {
                    next[index].toggle()
                }
                return next
            }
        }
        .search(
            from: Array(repeating: false, count: machine.lights.count),
            using: .bfs()
        )
        .first { $0.currentVertex == machine.lights }
        .map { Int($0.depth()) } ?? 0
    }

    private func minButtonPressesForJoltages(_ machine: Machine) -> Int {
        var matrix = Array(
            repeating: Array(repeating: 0, count: machine.buttons.count),
            count: machine.joltages.count
        )
        for (buttonIndex, button) in machine.buttons.enumerated() {
            for counterIndex in button {
                matrix[counterIndex][buttonIndex] = 1
            }
        }
        return ILPSolver.solve(matrix: matrix, targets: machine.joltages)?.sum() ?? 0
    }
}

private struct Machine {
    typealias Lights = [Bool]
    typealias Button = Set<Int>
    let lights: Lights
    let buttons: [Button]
    let joltages: [Int]
}

private enum ILPSolver {
    private struct Rational: Equatable {
        let num: Int
        let den: Int
        
        init(_ num: Int, _ den: Int = 1) {
            if den == 0 {
                self.num = num
                self.den = 0
            } else if num == 0 {
                self.num = 0
                self.den = 1
            } else {
                let g = greatestCommonDivisor(abs(num), abs(den))
                let sign = den < 0 ? -1 : 1
                self.num = sign * num / g
                self.den = sign * den / g
            }
        }
        
        var isZero: Bool { num == 0 }
        var isInteger: Bool { den == 1 }
        var intValue: Int { num / den }
        
        static func + (lhs: Rational, rhs: Rational) -> Rational {
            Rational(lhs.num * rhs.den + rhs.num * lhs.den, lhs.den * rhs.den)
        }
        
        static func - (lhs: Rational, rhs: Rational) -> Rational {
            Rational(lhs.num * rhs.den - rhs.num * lhs.den, lhs.den * rhs.den)
        }
        
        static func * (lhs: Rational, rhs: Rational) -> Rational {
            Rational(lhs.num * rhs.num, lhs.den * rhs.den)
        }
        
        static func / (lhs: Rational, rhs: Rational) -> Rational {
            Rational(lhs.num * rhs.den, lhs.den * rhs.num)
        }
    }
    
    /// Solves Ax = b for minimum sum of x, where x must be non-negative integers
    static func solve(matrix: [[Int]], targets: [Int]) -> [Int]? {
        let numCols = matrix[0].count
        let aug = matrix.enumerated().map { i, row in
            row.map { Rational($0) } + [Rational(targets[i])]
        }
        
        let (rref, pivotCols) = gaussianElimination(aug)
        
        // Check for inconsistency (non-zero in RHS after all pivots)
        let isConsistent = rref.dropFirst(pivotCols.count).allSatisfy { $0[numCols].isZero }
        guard isConsistent else { return nil }
        
        let freeVars = (0 ..< numCols).filter { !pivotCols.contains($0) }
        
        // Unique solution
        if freeVars.isEmpty {
            let solution = extractSolution(rref: rref, pivotCols: pivotCols, freeValues: [], freeVars: [], numCols: numCols)
            return solution.allSatisfy({ $0.isInteger && $0.num >= 0 }) ? solution.map(\.intValue) : nil
        }

        return searchFreeVariables(aug: rref, pivotCols: pivotCols, freeVars: freeVars, numCols: numCols)
    }
    
    /// Gaussian elimination to Reduced Row Echelon Form
    private static func gaussianElimination(_ matrix: [[Rational]]) -> (rref: [[Rational]], pivotCols: [Int]) {
        let numCols = matrix[0].count
        var aug = matrix
        var pivotCols: [Int] = []
        var pivotRow = 0
        
        for col in 0 ..< numCols where pivotRow < aug.count {
            // Find first non-zero pivot in this column
            guard let swapRow = (pivotRow ..< aug.count).first(where: { !aug[$0][col].isZero }) else { continue }
            aug.swapAt(pivotRow, swapRow)
            
            // Scale pivot row to make pivot = 1
            let pivot = aug[pivotRow][col]
            aug[pivotRow] = aug[pivotRow].map { $0 / pivot }
            
            // Eliminate this column in all other rows
            for row in 0 ..< aug.count where row != pivotRow && !aug[row][col].isZero {
                let factor = aug[row][col]
                aug[row] = zip(aug[row], aug[pivotRow]).map { $0 - factor * $1 }
            }
            
            pivotCols.append(col)
            pivotRow += 1
        }
        
        return (aug, pivotCols)
    }
    
    private static func extractSolution(
        rref: [[Rational]],
        pivotCols: [Int],
        freeValues: [Int],
        freeVars: [Int],
        numCols: Int
    ) -> [Rational] {
        var solution = [Rational](repeating: Rational(0), count: numCols)
        
        // Set free variable values
        for (i, fv) in freeVars.enumerated() where i < freeValues.count {
            solution[fv] = Rational(freeValues[i])
        }
        
        // Compute pivot variable values: x_pivot = RHS - sum(coeff * x_free)
        for (i, pc) in pivotCols.enumerated() {
            var val = rref[i][numCols]
            for (j, fv) in freeVars.enumerated() where j < freeValues.count {
                val = val - rref[i][fv] * Rational(freeValues[j])
            }
            solution[pc] = val
        }
        
        return solution
    }
    
    private static func searchFreeVariables(
        aug: [[Rational]],
        pivotCols: [Int],
        freeVars: [Int],
        numCols: Int
    ) -> [Int]? {
        // Max bound based on RHS values in pivot rows
        let maxBound = min(500, (pivotCols.indices.map { abs(aug[$0][numCols].num) }.max() ?? 100) * 2)
        var best: (solution: [Int], sum: Int)?
        
        func search(_ idx: Int, _ values: [Int]) {
            if idx == freeVars.count {
                let solution = extractSolution(rref: aug, pivotCols: pivotCols, freeValues: values, freeVars: freeVars, numCols: numCols)
                if solution.allSatisfy({ $0.isInteger && $0.num >= 0 }) {
                    let sum = solution.map(\.intValue).sum()
                    if best == nil || sum < best!.sum {
                        best = (solution.map(\.intValue), sum)
                    }
                }
                return
            }
            
            for val in 0 ... maxBound {
                let partial = values + [val]
                
                // Prune if any pivot variable would go negative
                let canPrune = pivotCols.indices.contains { row in
                    var maxPossible = aug[row][numCols]
                    for (j, fv) in freeVars.enumerated() {
                        let coeff = aug[row][fv]
                        let v = j < partial.count ? partial[j] : (coeff.num > 0 ? 0 : maxBound)
                        maxPossible = maxPossible - coeff * Rational(v)
                    }
                    return maxPossible.num < 0
                }
                
                if !canPrune {
                    search(idx + 1, partial)
                }
            }
        }
        
        search(0, [])
        return best?.solution
    }
}
