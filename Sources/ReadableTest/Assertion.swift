
class Assertion<T: Equatable> {
    func assertEqual(_ expression1: T?, _ expression2: T?, file: StaticString, line: UInt) {}
}
