@testable import ReadableTest
import XCTest


class SynchronousExpectationTests: XCTestCase {
    func test_toEqual_passes_correct_argument_to_assertion() {
        let spyAssertion = SpyAssertion<String>()
        let expectation = SynchronousExpectation(actualValue: "bbb", assertion: spyAssertion)
        
        
        expectation.toEqual("aaa")
        
        
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression1, "bbb")
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression2, "aaa")
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, #line - 6)
    }
    
    func test_toBeNill_passes_correct_argument_to_assertion() {
        let spyAssertion = SpyAssertion<String>()
        let maybeString: String? = nil
        let expectation = SynchronousExpectation(actualValue: maybeString, assertion: spyAssertion)
        
        
        expectation.toBeNil()
        
        
        XCTAssertEqual(spyAssertion.assertNil_argumnent_expression, nil)
        XCTAssertEqual(spyAssertion.assertNil_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertNil_argumnent_line, #line - 5)
    }
    
    func test_toBeEmpty_passes_correct_argumnent_to_assertion() {
        let spyAssertion = SpyAssertion<Int>()
        let expectation = SynchronousExpectation(actualValue: ["aaa"], assertion: spyAssertion)
        
        
        expectation.toBeEmpty()
        
        
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression1, 1)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression2, 0)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, #line - 6)
    }
}
