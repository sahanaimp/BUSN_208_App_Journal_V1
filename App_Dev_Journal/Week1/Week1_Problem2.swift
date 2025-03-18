/*2. Think of an app like Carmax and design a data structure for such an app. Then write a function that can be called to to create comparison for 3 vehicles. Design a metric that gives a score based on the user's preferences. For example, if I like sports car and don't care about gas cost, then the scoring metric for a car should reflect that. You can keep things simple and develop the code as a proof of concept.*/
import Foundation

struct Car {
    let name: String
    let price: Double
    let mpg: Double
    let horsepower: Double
    let isSportsCar: Bool
}

struct UserPreference {
    let priceWeight: Double
    let mpgWeight: Double
    let horsepowerWeight: Double
    let sportsCarWeight: Double

    func score(for car: Car) -> Double {
        let priceScore = 100 - (car.price / 1000) * priceWeight
        let mpgScore = car.mpg * mpgWeight
        let horsepowerScore = car.horsepower * horsepowerWeight
        let sportsCarScore = (car.isSportsCar ? 100 : 0) * sportsCarWeight

        return priceScore + mpgScore + horsepowerScore + sportsCarScore
    }
}

func compareCars(cars: [Car], userPreference: UserPreference) {
    let sortedCars = cars.sorted { userPreference.score(for: $0) > userPreference.score(for: $1) }
    
    for (index, car) in sortedCars.enumerated() {
        print("\(index + 1). \(car.name) - Score: \(userPreference.score(for: car))")
    }
}
