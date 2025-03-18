import SwiftUI
import CoreHaptics

enum Habit: String, CaseIterable, Codable {
    case gym = "Gym"
    case pray = "Pray"
    case callParents = "Call Parents"
    case study = "Study"
    case compliment = "Compliment Someone"
    
    var icon: String {
        switch self {
        case .gym: return "figure.run"
        case .pray: return "hands.sparkles"
        case .callParents: return "phone.fill"
        case .study: return "book.fill"
        case .compliment: return "heart.fill"
        }
    }
}

struct ContentView: View {
    @StateObject private var habitData = HabitData()
    @State private var engine: CHHapticEngine?
    @State private var showingStats = false
    @State private var isGreenTheme = false
    @State private var selectedHabit: Habit = .gym
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background with gradient
                BackgroundView(isGreenTheme: isGreenTheme)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Habit Selection
                        VStack(spacing: 10) {
                            Text("Select Habit")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(Habit.allCases, id: \.self) { habit in
                                    Button(action: {
                                        withAnimation {
                                            selectedHabit = habit
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Image(systemName: habit.icon)
                                                .font(.system(size: 20))
                                            Text(habit.rawValue)
                                                .font(.system(size: 12, weight: .medium))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedHabit == habit ? 
                                                    (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)) :
                                                    Color.white.opacity(0.9))
                                        )
                                        .foregroundColor(selectedHabit == habit ? .white : 
                                            (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)))
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Streak Counter
                        VStack(spacing: 4) {
                            Text("Current Streak")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                            Text("\(habitData.getStreak(for: selectedHabit)) days")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                                .shadow(color: (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                        
                        // Today's Count
                        VStack(spacing: 4) {
                            Text("Today's Completions")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                            Text("\(habitData.getTodayCount(for: selectedHabit))")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                                .shadow(color: (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                        
                        // Complete Button
                        Button(action: {
                            habitData.addEntry(for: selectedHabit)
                            triggerHaptic()
                        }) {
                            Text("Complete \(selectedHabit.rawValue)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 240, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255),
                                            isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255).opacity(0.8) : Color(red: 233/255, green: 30/255, blue: 99/255).opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        // Change Layout Button
                        Button(action: {
                            withAnimation {
                                isGreenTheme.toggle()
                            }
                        }) {
                            Text("Change Layout")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 240, height: 50)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            isGreenTheme ? Color(red: 233/255, green: 30/255, blue: 99/255) : Color(red: 34/255, green: 139/255, blue: 34/255),
                                            isGreenTheme ? Color(red: 233/255, green: 30/255, blue: 99/255).opacity(0.8) : Color(red: 34/255, green: 139/255, blue: 34/255).opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(25)
                                .shadow(color: (isGreenTheme ? Color(red: 233/255, green: 30/255, blue: 99/255) : Color(red: 34/255, green: 139/255, blue: 34/255)).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Habit Tracker")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                        .shadow(color: (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.2), radius: 5, x: 0, y: 2)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255))
                            .shadow(color: (isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .sheet(isPresented: $showingStats) {
                StatsView(entries: habitData.entries)
            }
            .onAppear(perform: prepareHaptics)
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptics error: \(error.localizedDescription)")
        }
    }
    
    private func triggerHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
}

struct BackgroundView: View {
    let isGreenTheme: Bool
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    isGreenTheme ? Color(red: 240/255, green: 255/255, blue: 240/255) : Color(red: 255/255, green: 240/255, blue: 245/255),
                    isGreenTheme ? Color(red: 230/255, green: 255/255, blue: 230/255) : Color(red: 255/255, green: 230/255, blue: 240/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Decorative elements
            ForEach(0..<5) { index in
                Image(systemName: "circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor((isGreenTheme ? Color(red: 34/255, green: 139/255, blue: 34/255) : Color(red: 233/255, green: 30/255, blue: 99/255)).opacity(0.1))
                    .blur(radius: 8)
                    .offset(x: CGFloat.random(in: -150...150),
                            y: CGFloat.random(in: -300...300))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
