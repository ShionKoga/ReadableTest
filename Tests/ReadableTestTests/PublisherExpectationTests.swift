@testable import ReadableTest
import XCTest
import Combine


final class PublisherExpectationTests: ReadableTestCase {
    var cancellables = Set<AnyCancellable>()
    let dummyWait = { (_: [XCTestExpectation], _: TimeInterval) -> Void in }
    
    var viewModel: ExampleObservableObject!
    
    override func setUp() {
        viewModel = ExampleObservableObject()
    }
    
    func test_toEqual_passes_correct_argument_to_assertion() {
        let spyAssertion = SpyAssertion<String>()
        let expectation = PublisherExpectation<String, Published<String>.Publisher, String>(
            viewModel.$text,
            cancellables,
            dummyWait,
            assertion: spyAssertion
        )
        
        
        expectation.toEqual("aaa")
        
        
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression1, "bbb")
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression2, "aaa")
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, #line - 6)
    }
    
    func test_toEqual_compares_specified_number_of_publication() {
        expect(viewModel.$text).on(publication: 1).toEqual("ccc")
    }
    
    func test_toEqual_calles_passed_wait_function_correctlly() {
        let mockWait = { (expectations: [XCTestExpectation], seconds: TimeInterval) -> Void in
            XCTAssertEqual("\(type(of: expectations))", "Array<XCTestExpectation>")
            XCTAssertEqual(seconds, 1)
        }
        
        let expectation = PublisherExpectation<String, Published<String>.Publisher, String>(
            viewModel.$text,
            cancellables,
            mockWait,
            assertion: DummyAssertion()
        )
        
        expectation.toEqual("")
    }
    
    func test_toEqual_with_keyPath_passes_correct_argument_to_assertion() {
        let spyAssertion = SpyAssertion<Int>()
        let expectation = PublisherExpectation<Person, Published<Person>.Publisher, Int>(
            viewModel.$person,
            cancellables,
            dummyWait,
            assertion: spyAssertion
        )
        
        
        expectation.toEqual(20, keyPath: \.age)
        
        
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression1, 10)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression2, 20)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, #line - 6)
    }
    
    func test_toEqual_with_keyPath_compares_specified_number_of_publification() {
        expect(viewModel.$person).on(publication: 1).toEqual(30, keyPath: \.age)
    }
    
    func test_toEqual_with_keyPath_calles_passed_wait_function_correctlly() {
        let mockWait = { (expectations: [XCTestExpectation], seconds: TimeInterval) -> Void in
            XCTAssertEqual("\(type(of: expectations))", "Array<XCTestExpectation>")
            XCTAssertEqual(seconds, 1)
        }
        
        let expectation = PublisherExpectation<Person, Published<Person>.Publisher, Int>(
            viewModel.$person,
            cancellables,
            mockWait,
            assertion: DummyAssertion()
        )
        
        expectation.toEqual(0, keyPath: \.age)
    }
    
    func test_toEqualPartially_passes_correct_argument_to_assertion() {
        let spyAssertion = SpyAssertion<Int>()
        let expectation = PublisherExpectation<[Person], Published<[Person]>.Publisher, Int>(
            viewModel.$people,
            cancellables,
            dummyWait,
            assertion: spyAssertion
        )
        
        
        expectation.toEqualPartially([
            .init(keyPath: \.first?.age, value: 40)
        ])
        
        
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression1, 30)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_expression2, 40)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_file, #file)
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, #line - 7)
    }
    
    func test_toEqualPartially_compares_specified_number_of_publification() {
        expect(viewModel.$people).on(publication: 1).toEqualPartially([
            .init(keyPath: \.first?.age, value: 50)])
    }
    
    func test_toEqualPartially_calles_passed_wait_function_correctlly() {
        let mockWait = { (expectations: [XCTestExpectation], seconds: TimeInterval) -> Void in
            XCTAssertEqual("\(type(of: expectations))", "Array<XCTestExpectation>")
            XCTAssertEqual(seconds, 1)
        }
        
        let expectation = PublisherExpectation<[Person], Published<[Person]>.Publisher, Int>(
            viewModel.$people,
            cancellables,
            mockWait,
            assertion: DummyAssertion()
        )
        
        expectation.toEqualPartially([])
    }
}
