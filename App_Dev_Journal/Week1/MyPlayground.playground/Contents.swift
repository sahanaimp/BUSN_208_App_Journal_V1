import UIKit

// Property wrapper to validate price
@propertyWrapper
struct ValidatedPrice {
    private var value: Double
    var wrappedValue: Double {
        get { value }
        set { value = max(newValue, 0) }
    }
    
    init(wrappedValue: Double) {
        self.value = max(wrappedValue, 0)
    }
}

// Structure to represent a car
// Make, model, year
struct Car {
    var make: String
    var model: String
    var year: String
    
    @ValidatedPrice var price: Double
    
    func carDescription() -> String {
        return "\(year) \(make) \(model) : \(price)"
    }
}

// Base class for person
class Person {
    var name: String
    var contactNumber: String
    
    init(name: String, contactNumber: String) {
        self.name = name
        self.contactNumber = contactNumber
    }
    
    func carInfo() -> String {
        return "Name: \(name), Contact Number: \(contactNumber)"
    }
}

// Subclass for customer
class Customer: Person {
    var purchasedCars: [Car] = [] // Array
    
    func addCar(car: Car) {
        purchasedCars.append(car)
    }
    
    func listPurchasedCars() -> String {
        return purchasedCars.map { $0.carDescription() }.joined(separator: "\n")
    }
}

// Subclass for salesperson
class SalesPerson: Person {
    var employeeID: String
    
    init(name: String, contactNumber: String, employeeID: String) {
        self.employeeID = employeeID
        super.init(name: name, contactNumber: contactNumber)
    }
    
    override func carInfo() -> String {
        return super.carInfo() + ", Employee ID: \(employeeID)"
    }
}

// Execution or calling or creating instances
let car1 = Car(make: "Toyota", model: "Camry", year: "2020", price: 2000)
let car2 = Car(make: "Ford", model: "Mustang", year: "2024", price: 1500)

let customer = Customer(name: "John Doe", contactNumber: "123-123-1233")
customer.addCar(car: car1)
customer.addCar(car: car2)

let salesperson = SalesPerson(name: "Jane Wick", contactNumber: "911", employeeID: "1234")

print("Info about customer:")
print(customer.carInfo())
print("Cars purchased:")


print(customer.listPurchasedCars())
print("\nSalesPerson Info:")
print(salesperson.carInfo())

//HW
/*

 */
