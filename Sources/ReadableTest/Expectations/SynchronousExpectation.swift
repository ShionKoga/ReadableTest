import Foundation

class SynchronousExpectation<T: Equatable, X: Equatable> {
    private let assertion: Assertion<X>
    private let actualValue: T?
    
    init (actualValue: T?, assertion: Assertion<X> = XCTAssertion()) {
        self.actualValue = actualValue
        self.assertion = assertion
    }
    
    func toEqual(
        _ expectValue: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T == X {
        assertion.assertEqual(actualValue, expectValue, file: file, line: line)
    }
    
    func toBeNil(
        file: StaticString = #file,
        line: UInt = #line
    ) where T == X {
        assertion.assertNil(actualValue, file: file, line: line)
    }
    
    func toBeEmpty<Y: Equatable>(
        file: StaticString = #file,
        line: UInt = #line
    ) where T == Array<Y>, X == Int {
        assertion.assertEqual(actualValue?.count, 0, file: file, line: line)
    }
}
