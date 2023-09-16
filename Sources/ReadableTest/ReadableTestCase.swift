import XCTest
import Combine


class ReadableTestCase: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func expect<T: Equatable, P: Publisher, X: Equatable>(_ publisher: P) -> PublisherExpectation<T, P, X> {
        return PublisherExpectation(publisher, cancellables, wait)
    }
    
    func expect<T: Equatable, X: Equatable>(_ actualValue: T?) -> SynchronousExpectation<T, X> {
        return SynchronousExpectation(actualValue: actualValue)
    }
}
