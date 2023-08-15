import XCTest
import Combine


class ReadableTestCase: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    func expect<T: Equatable, P: Publisher, X: Equatable>(_ publisher: P) -> PublisherExpectation<T, P, X> {
        return PublisherExpectation(publisher, cancellables, wait)
    }
}
