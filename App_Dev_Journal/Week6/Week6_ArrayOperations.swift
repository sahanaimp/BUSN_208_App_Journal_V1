/*Week 6: Anything
Create an array of integers, add multiple elements to it, remove elements, reverse the array, sort the array, determine if it contains a particular value, and finally loop through the entire array to print the values.
*/

import Foundation

var numbers: [Int] = [10, 20, 30, 40]


print("Initial array: \(numbers)")

numbers.append(50)
print("After appending 50: \(numbers)")

numbers.insert(15, at: 1)
print("After inserting 15 at index 1: \(numbers)")


if let index = numbers.firstIndex(of: 30) {
    numbers.remove(at: index)
    print("After removing 30: \(numbers)")
} else {
    print("30 not found in the array")
}

numbers.append(60)
print("After appending 60: \(numbers)")

numbers.insert(5, at: 0)
print("After inserting 5 at index 0: \(numbers)")

if let index = numbers.firstIndex(of: 20) {
    numbers.remove(at: index)
    print("After removing 20: \(numbers)")
} else {
    print("20 not found in the array")
}

// Loop through array and print elements
print("Final array values:")
for number in numbers {
    print(number)
}

print("Loop with index:")
for (index, number) in numbers.enumerated() {
    print("Index \(index): Value \(number)")
}

// Reverse loop
print("Reverse loop:")
for number in numbers.reversed() {
    print(number)
}

// Sorting and printing sorted array
numbers.sort()
print("Sorted array: \(numbers)")


numbers.removeLast()
print("After removing last element: \(numbers)")


numbers.removeFirst()
print("After removing first element: \(numbers)")

// Checking if array contains a value
let checkValue = 40
if numbers.contains(checkValue) {
    print("\(checkValue) is in the array")
} else {
    print("\(checkValue) is not in the array")
}

print("Final state of the array: \(numbers)")
