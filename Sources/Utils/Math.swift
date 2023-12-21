import Foundation

// MARK: LCM

@_disfavoredOverload
@inlinable public func lowestCommonMultiple(_ numbers: Int...) -> Int {
    lowestCommonMultiple(of: numbers)
}

@inlinable public func lowestCommonMultiple(of numbers: some Sequence<Int>) -> Int {
    numbers.reduce(lowestCommonMultiple) ?? numbers.product()
}

@inlinable public func lowestCommonMultiple(_ a: Int, _ b: Int) -> Int {
    a * b / greatestCommonDivisor(a, b)
}

extension Sequence {
    @inlinable public func lowestCommonMultiple() -> Int where Element == Int {
        Utils.lowestCommonMultiple(of: self)
    }

    @inlinable public func lowestCommonMultiple(of property: (Element) -> Int) -> Int {
        map(property).lowestCommonMultiple()
    }
}

// MARK: GCD

@_disfavoredOverload
@inlinable public func greatestCommonDivisor(_ numbers: Int...) -> Int {
    greatestCommonDivisor(of: numbers)
}

@inlinable public func greatestCommonDivisor(of numbers: some Sequence<Int>) -> Int {
    numbers.reduce(greatestCommonDivisor) ?? 1
}

@inlinable public func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
    var num1 = a
    var num2 = b
    while num2 != 0 {
        let temp = num2
        num2 = num1 % num2
        num1 = temp
    }
    return num1
}

extension Sequence {
    @inlinable public func greatestCommonDivisor() -> Int where Element == Int {
        Utils.greatestCommonDivisor(of: self)
    }

    @inlinable public func greatestCommonDivisor(of property: (Element) -> Int) -> Int {
        map(property).greatestCommonDivisor()
    }
}

// MARK: Quadratic equation

@inlinable public func predictValueInQuadraticEquation(for x: Double, given values: [(x: Double, y: Double)]) -> Double {
    let (a, b, c) = quadraticFit(for: values)
    return a * x * x + b * x + c
}

@inlinable public func quadraticFit(for values: [(x: Double, y: Double)]) -> (a: Double, b: Double, c: Double) {
    let n = Double(values.count)

    let sumX = values.sum(of: \.x)
    let sumX2 = values.sum { pow($0.x, 2) }
    let sumX3 = values.sum { pow($0.x, 3) }
    let sumX4 = values.sum { pow($0.x, 4) }

    let sumY = values.sum(of: \.y)
    let sumXY = values.sum(of: *)
    let sumX2Y = values.sum { pow($0.x, 2) * $0.y }

    let matrix = [
        [sumX4, sumX3, sumX2],
        [sumX3, sumX2, sumX],
        [sumX2, sumX, n]
    ]

    let constants = [sumX2Y, sumXY, sumY]

    // Solving the linear equations using Cramer's rule
    let determinant = { (matrix: [[Double]]) -> Double in
        let a = matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        let b = matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        let c = matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
        return a - b + c
    }

    let det = determinant(matrix)

    var aMatrix = matrix
    var bMatrix = matrix
    var cMatrix = matrix

    for i in 0...2 {
        aMatrix[i][0] = constants[i]
        bMatrix[i][1] = constants[i]
        cMatrix[i][2] = constants[i]
    }

    let a = determinant(aMatrix) / det
    let b = determinant(bMatrix) / det
    let c = determinant(cMatrix) / det

    return (a, b, c)
}
