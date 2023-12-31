import XCTest

class XCTAssertion<T: Equatable>: Assertion<T> {
    override func assertEqual(
        _ expression1: T?,
        _ expression2: T?,
        file: StaticString,
        line: UInt
    ) where T : Equatable {
        XCTAssertEqual(expression1, expression2, file: file, line: line)
    }
    
    override func assertNil(_ expression: T?, file: StaticString, line: UInt) {
        XCTAssertNil(expression, file: file, line: line)
    }
}
