public func nonNegativeModulo(of lhs: Int, by rhs: Int) -> Int {
    let result = lhs % rhs
    return result >= 0 ? result : result + rhs
}
