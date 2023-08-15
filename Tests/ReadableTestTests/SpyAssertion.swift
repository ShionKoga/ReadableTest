@testable import ReadableTest


class SpyAssertion<T: Equatable>: Assertion<T> {
    var assertEqual_argumnent_expression1: T? = nil
    var assertEqual_argumnent_expression2: T? = nil
    var assertEqual_argumnent_file: StaticString? = nil
    var assertEqual_argumnent_line: UInt? = nil
    override func assertEqual(_ expression1: T?, _ expression2: T?, file: StaticString, line: UInt) {
        assertEqual_argumnent_expression1 = expression1
        assertEqual_argumnent_expression2 = expression2
        assertEqual_argumnent_file = file
        assertEqual_argumnent_line = line
    }
}
