//: [Previous](@previous)

import Foundation

class Dog {
    func bark() {
        print("bark")
    }
}

class Action {
    func doSomething(then: @escaping (() -> Void)) {
        then()
    }
    deinit {
        print("Action class is DEAD")
    }
}

class MainClass {
    let dog: Dog = Dog()
    var action: Action? = Action()
    
    init() {
        print("0 : \(CFGetRetainCount(self))") // 2 (1)
        action?.doSomething(then: { [weak self] in
            print("1 : \(CFGetRetainCount(self))") // 2 (1)
            guard let self = self else { return }
            self.action = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("3 : \(CFGetRetainCount(self))") // 2 (1)
                self.dog.bark()
                print("4 : \(CFGetRetainCount(self))") // 2 (1)
            }
        })
        print("2 : \(CFGetRetainCount(self))") // 2 (1)
    }
    
    deinit {
        print("5 : \(CFGetRetainCount(self))") // 2 (1)
        print("mainClass deinit")
    }
}

MainClass() // 1
