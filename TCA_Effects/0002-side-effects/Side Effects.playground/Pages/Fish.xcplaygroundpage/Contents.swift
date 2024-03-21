import Foundation

extension Array {
    func myMap<T>(_ transform: (Self.Element) throws -> T) rethrows -> [T] {
        var result = [T]()
        for i in self {
            result.append(try transform(i))
        }
        return result
    }
    
    func myFilter(_ isIncluded: (Self.Element) throws -> Bool) rethrows -> [Self.Element] {
        var result = [Self.Element]()
        for i in self {
            guard
                try isIncluded(i)
            else {
                continue
            }
            result.append(i)
        }
        return result
    }
    
    func myReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Self.Element) throws -> Result
    ) rethrows -> Result {
        var result: Result = initialResult
        for i in self {
            result = try nextPartialResult(result, i)
        }
        return result
    }
}

var intArray: [Int] = [1,2,3,4,5]
print("Map:")
intArray.map { print($0 + 1) }
print("myMap:")
intArray.myMap { print($0 + 1) }
print("========================")
print("reduce:")
let numbers = [1, 2, 3, 4]
print(numbers.reduce(0, { x, y in
    x + y
}))
print("myReduce:")
print(numbers.myReduce(0, { x, y in
    x + y
}))
print("========================")

let cast = ["Vivien", "Marlon", "Kim", "Karl"]
print("filter:")
print(cast.filter { $0.count < 5 })
print("myFilter:")
print(cast.myFilter { $0.count < 5 })

