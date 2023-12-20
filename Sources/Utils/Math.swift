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
