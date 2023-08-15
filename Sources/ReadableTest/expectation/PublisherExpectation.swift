import XCTest
import Combine

class PublisherExpectation<T: Equatable, P: Publisher, X: Equatable> {
    private let publisher: P
    private var cancellables: Set<AnyCancellable>
    private let wait: (_ expectations: [XCTestExpectation], _ seconds: TimeInterval) -> Void
    private let assertion: Assertion<X>
    
    init(
        _ publisher: P,
        _ cancellables: Set<AnyCancellable>,
        _ wait: @escaping (_ expectations: [XCTestExpectation], _ seconds: TimeInterval) -> Void,
        assertion: Assertion<X> = XCTAssertion<X>()
    ) {
        self.publisher = publisher
        self.cancellables = cancellables
        self.wait = wait
        self.assertion = assertion
    }
    
    private var dropCount: Int = 0
    func on(publication number: Int) -> Self {
        self.dropCount = number
        return self
    }
}

extension PublisherExpectation where P == Published<T>.Publisher, T == X {
    func toEqual(
        _ expectedValue: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                self.assertion.assertEqual(actualValue, expectedValue, file: file, line: line)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait([expectation], 1)
    }
}

extension PublisherExpectation where P == Published<T>.Publisher {
    func toEqual(
        _ expectedValue: X,
        keyPath: KeyPath<T, X>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                self.assertion.assertEqual(
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
    
    func toEqualPartially(
        _ partialExpectations: [PartialExpectation<T, X?>]
    ) {
        let expectation = XCTestExpectation()
        publisher
            .dropFirst(dropCount)
            .sink { actualValue in
                partialExpectations.forEach { partialExpectation in
                    self.assertion.assertEqual(
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
    
    struct PartialExpectation<T, X> {
        let keyPath: KeyPath<T, X>
        let value: X
        let file: StaticString
        let line: UInt
        
        init(
            keyPath: KeyPath<T, X>,
            value: X,
            file: StaticString = #file,
            line: UInt = #line
        ) {
            self.keyPath = keyPath
            self.value = value
            self.file = file
            self.line = line
        }
    }
}

