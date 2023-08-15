import XCTest
import Combine


class CustomTestCase: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func expect<T: Equatable, P: Publisher>(_ publisher: P) -> Expectation<T, P> {
        return Expectation(publisher, cancellables, wait)
    }
    
    func it(_ testName: String, _ body: () -> Void) {
        
    }
}

class Expectation<T: Equatable, P: Publisher> {
    private let publisher: P
    private var cancellables: Set<AnyCancellable>
    private let wait: (_ expectations: [XCTestExpectation], _ seconds: TimeInterval) -> Void
    
    init(
        _ publisher: P,
        _ cancellables: Set<AnyCancellable>,
        _ wait: @escaping (_ expectations: [XCTestExpectation], _ seconds: TimeInterval) -> Void
    ) {
        self.publisher = publisher
        self.cancellables = cancellables
        self.wait = wait
    }
    
    private var dropCount: Int = 0
    func on(publication number: Int) -> Self {
        self.dropCount = number
        return self
    }
}

extension Expectation where P == Published<T>.Publisher {
    func toEqual(
        _ expectedValue: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                XCTAssertEqual(actualValue, expectedValue, file: file, line: line)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait([expectation], 1)
    }
    
    func toEqual<X: Equatable>(
        _ expectedValue: X,
        keyPath: KeyPath<T, X>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                XCTAssertEqual(
                    actualValue[keyPath: keyPath],
                    expectedValue,
                    file: file,
                    line: line
                )
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait([expectation], 1)
    }
    
    func toEqualPartially<X: Equatable>(
        _ partialExpectations: [PartialExpectation<T, X>]
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                partialExpectations.forEach { partialExpectation in
                    XCTAssertEqual(
                        actualValue[keyPath: partialExpectation.keyPath],
                        partialExpectation.value,
                        file: partialExpectation.file,
                        line: partialExpectation.line
                    )
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait([expectation], 1)
    }
}

struct PartialExpectation<T, X> {
    let keyPath: KeyPath<T, X>
    let value: X
    let file: StaticString
    let line: UInt
    
    init(keyPath: KeyPath<T, X>, value: X, file: StaticString = #file, line: UInt = #line) {
        self.keyPath = keyPath
        self.value = value
        self.file = file
        self.line = line
    }
}


