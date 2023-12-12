import Utils

protocol Day {
    init(_ input: Input) throws
    static var year: Int { get }
    static var day: Int { get }
}

extension Day {
    private static var className: String {
        String(reflecting: Self.self)
    }

    static var day: Int {
        className.integers.last!
    }

    static var year: Int {
        className.integers.first!
    }
}
