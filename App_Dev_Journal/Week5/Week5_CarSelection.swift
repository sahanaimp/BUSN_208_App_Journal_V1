/*Week 5: For the coding journal, your task this week is to replicate the process we used to create the front end of TicTacToe but for the CarMax app we discussed earlier in class. Write the new enums you would need, code relevant user interface to pick an option and keep track of such options using static variables. Document your code so that when you submit it for grades later we can understand what you have done.
*/
import SwiftUI

/// Enum representing different types of cars
enum CarType: String, CaseIterable {
    case sedan = "Sedan"
    case suv = "SUV"
    case truck = "Truck"
    case sportsCar = "Sports Car"
}

/// Enum representing fuel types
enum FuelType: String, CaseIterable {
    case gasoline = "Gasoline"
    case electric = "Electric"
    case hybrid = "Hybrid"
    case diesel = "Diesel"
}

/// Enum representing transmission type
enum TransmissionType: String, CaseIterable {
    case automatic = "Automatic"
    case manual = "Manual"
}

/// A struct to store user-selected preferences with static variables
struct UserPreferences {
    static var selectedCarType: CarType = .sedan
    static var selectedFuelType: FuelType = .gasoline
    static var selectedTransmission: TransmissionType = .automatic
}

///car selection interface
struct CarSelectionView: View {
    @State private var selectedCarType: CarType = UserPreferences.selectedCarType
    @State private var selectedFuelType: FuelType = UserPreferences.selectedFuelType
    @State private var selectedTransmission: TransmissionType = UserPreferences.selectedTransmission

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Your Preferences")
                    .font(.title)
                    .fontWeight(.bold)

                /// Picker for Car Type
                Picker("Car Type", selection: $selectedCarType) {
                    ForEach(CarType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                /// Picker for Fuel Type
                Picker("Fuel Type", selection: $selectedFuelType) {
                    ForEach(FuelType.allCases, id: \.self) { fuel in
                        Text(fuel.rawValue).tag(fuel)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                /// Picker for Transmission Type
                Picker("Transmission", selection: $selectedTransmission) {
                    ForEach(TransmissionType.allCases, id: \.self) { transmission in
                        Text(transmission.rawValue).tag(transmission)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                /// Button to Save Preferences
                Button(action: savePreferences) {
                    Text("Save Preferences")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("CarMax Preferences")
        }
    }

    /// Saves user preferences to static variables
    func savePreferences() {
        UserPreferences.selectedCarType = selectedCarType
        UserPreferences.selectedFuelType = selectedFuelType
        UserPreferences.selectedTransmission = selectedTransmission
        print("Preferences Saved: \(selectedCarType.rawValue), \(selectedFuelType.rawValue), \(selectedTransmission.rawValue)")
    }
}

/// Preview
struct CarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CarSelectionView()
    }
}

