
extension StaticString: Equatable {
    public static func == (lhs: StaticString, rhs: StaticString) -> Bool {
        return lhs.description == rhs.description
    }
}
