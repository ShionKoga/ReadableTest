# ReadableTest

[![CI](https://github.com/ShionKoga/ReadableTest/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/ShionKoga/ReadableTest/actions/workflows/main.yml)
[![Release](https://img.shields.io/github/v/release/ShionKoga/ReadableTest)](https://github.com/ShionKoga/ReadableTest/releases/latest)
[![GitHub license](https://img.shields.io/github/license/ShionKoga/ReadableTest.svg)](https://github.com/ShionKoga/ReadableTest/blob/master/LICENSE)

# Background: Expressing Outcomes Using Assertions in XCTest

Testing Combine's Publisher only with XCTest would be a very complex description.

For example, XCTest has you write:

```Swift

// SUT
class ItemListViewModel: ObservableObject {
    @Published var items = [String]()
    
    func addItem(_ item: String) {
        items.append(item)
    }
}

// Test
class ItemListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func test_after_adding_apple__ViewModel_publishes_new_array_with_appleadded() {
        let viewModel = ItemListViewModel()
        
        
        viewModel.addItem("apple")
        
        
        let expectation = XCTestExpectation()
        viewModel.$items
            .dropFirst()
            .sink { newItems in
                XCTAssertEqual(newItems, ["apple"])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation])
    }
}
```
Testing Combine's Publisher only with XCTest have a couple of drawbacks:

1. Since we are testing the Publisher, of course we need to subscribe to it.
2. To avoid freeing memory immediately, it must be stored in a set of `AnyCancellable` defined outside the function
3. Since it is an asynchronous test, we have to instantiate `XCTestExpectation` and wait for the `fullfill()` to be executed

ReadableTest addresses these drowbacks.

# Testing with ReadableTest

ReadableTest allows you to express expectations more easier or read expectations more instantly.

```Swift
//SUT
class ItemListViewModel: ObservableObject {
    @Published var items = [String]()
    
    func addItem(_ item: String) {
        items.append(item)
    }
}

//Test
import ReadableTest

class ItemListViewModelTests: ReadableTestCase {
    func test_after_adding_apple__ViewModel_publishes_new_array_with_apple_added() {
        let viewModel = ItemListViewModel()
        
        
        viewModel.addItem("apple")
        
        
        expect(viewModel.$items).on(publication: 1).toEqual(["apple"])
    }
}
```

> IMPORTANT: ReadableTest is a work in progress and does not support all aspects of testing. Features will be added as needed. If you see a feature you need, please please feel free to open an issue or make a PR.👍

# License

ReadableTest is released under the MIT License, Please see the [LICENSE](/LICENSE).
