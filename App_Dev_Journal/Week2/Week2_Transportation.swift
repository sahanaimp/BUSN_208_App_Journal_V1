/*Week 2: Anything
Write a enum representing different transportation modes: car, bus, bicycle, and walking. The enum should include a function that returns the estimated speed for each mode.
*/

import Foundation

enum TransportationMode {
    case car, bus, bicycle, walking

    // Function to return estimated speed for each mode
    func estimatedSpeed() -> Double {
        switch self {
        case .car:
            return 60.0 // mph
        case .bus:
            return 40.0
        case .bicycle:
            return 15.0
        case .walking:
            return 3.0
        }
    }

    // Function to check if the mode is eco-friendly
    func isEcoFriendly() -> Bool {
        switch self {
        case .bicycle, .walking:
            return true
        default:
            return false
        }
    }

    // Function to provide description of the mode
    func description() -> String {
        switch self {
        case .car:
            return "A fast and convenient mode of transport."
        case .bus:
            return "An affordable public transportation option."
        case .bicycle:
            return "A healthy and eco-friendly option."
        case .walking:
            return "The most basic and eco-friendly way to travel."
        }
    }

    // Function to suggest a suitable mode based on distance
    static func suitableMode(forDistance distance: Double) -> TransportationMode {
        if distance < 1.0 {
            return .walking
        } else if distance < 5.0 {
            return .bicycle
        } else if distance < 20.0 {
            return .bus
        } else {
            return .car
        }
    }
}
