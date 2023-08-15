import Combine

class ExampleObservableObject: ObservableObject {
    @Published var text: String = "bbb"
    @Published var person: Person = Person(age: 10)
    @Published var people: [Person] = [Person(age: 30)]
}

struct Person: Equatable {
    let age: Int
}
