import SwiftUI
import CoreHaptics

struct ContentView: View {
    @StateObject private var habitData = HabitData()
    @State private var engine: CHHapticEngine?
    @State private var showingStats = false
    @State private var isGreenTheme = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background with bows
                BackgroundView(isGreenTheme: isGreenTheme)
                
                VStack(spacing: 30) {
                    // Streak Counter
                    VStack {
                        Text("Current Streak 🔥")
                            .font(.custom("Baskerville", size: 24))
                            .foregroundColor(isGreenTheme ? .green : .pink)
                        Text("\(habitData.getStreak()) days")
                            .font(.custom("Baskerville-Bold", size: 56))
                            .foregroundColor(isGreenTheme ? .green : .pink)
                    }
                    
                    // Today's Count
                    VStack {
                        Text("Today's Completions ✨")
                            .font(.custom("Baskerville", size: 24))
                            .foregroundColor(isGreenTheme ? .green : .pink)
                        Text("\(habitData.getTodayCount())")
                            .font(.custom("Baskerville-Bold", size: 48))
                            .foregroundColor(isGreenTheme ? .green : .pink)
                    }
                    
                    // Complete Button
                    Button(action: {
                        habitData.addEntry()
                        triggerHaptic()
                    }) {
                        Text("Complete Habit 🎯")
                            .font(.custom("Baskerville-Bold", size: 28))
                            .foregroundColor(.white)
                            .frame(width: 280, height: 60)
                            .background(isGreenTheme ? Color.green : Color.pink)
                            .cornerRadius(30)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Change Layout Button
                    Button(action: {
                        withAnimation {
                            isGreenTheme.toggle()
                        }
                    }) {
                        Text("Change Layout 🌱")
                            .font(.custom("Baskerville-Bold", size: 28))
                            .foregroundColor(.white)
                            .frame(width: 280, height: 60)
                            .background(isGreenTheme ? Color.pink : Color.green)
                            .cornerRadius(30)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Spacer()
                }
                .padding()
            }
            //.navigationTitle("Habit Tracker")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("✿ Habit Tracker ✿")
                        .font(.custom("Baskerville-Bold", size: 28))
                        .foregroundColor(isGreenTheme ? .green : .pink)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingStats = true }) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(isGreenTheme ? .green : .pink)
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
            // Background color
            Color(red: isGreenTheme ? 230/255 : 255/255,
                  green: isGreenTheme ? 255/255 : 228/255,
                  blue: isGreenTheme ? 230/255 : 230/255)
                .ignoresSafeArea()
            
            // Decorative bows
            ForEach(0..<5) { index in
                Image(systemName: "bow.fill")
                    .font(.system(size: 100))
                    .foregroundColor((isGreenTheme ? Color.green : Color.pink).opacity(0.2))
                    .blur(radius: 5)
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
