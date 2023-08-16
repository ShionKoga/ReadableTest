import Combine
import Foundation

class ExampleObservableObject: ObservableObject {
    @Published var text: String = "bbb"
    @Published var person: Person = Person(age: 10)
    @Published var people: [Person] = [Person(age: 30)]
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.text = "ccc"
            self.person = Person(age: 30)
            self.people = [Person(age: 50)]
        }
    }
}

struct Person: Equatable {
    let age: Int
}
