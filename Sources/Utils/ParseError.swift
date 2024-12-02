public struct ParseError: Error {
    let message: String

    public init(_ message: String = "") {
        self.message = message
    }
}
