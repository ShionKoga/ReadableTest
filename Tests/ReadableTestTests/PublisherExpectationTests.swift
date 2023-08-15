@testable import ReadableTest
import XCTest
import Combine


final class PublisherExpectationTests: XCTestCase {
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
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, 26)
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
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, 45)
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
        XCTAssertEqual(spyAssertion.assertEqual_argumnent_line, 65)
    }
}
