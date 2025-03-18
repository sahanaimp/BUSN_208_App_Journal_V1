import SwiftUI

struct StatsView: View {
    let entries: [HabitEntry]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Habit.allCases, id: \.self) { habit in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: habit.icon)
                                    .font(.title2)
                                Text(habit.rawValue)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            ContributionGraphView(entries: entries.filter { $0.habit == habit })
                                .frame(height: 200)
                            
                            HStack {
                                StatCard(title: "Total Completions", value: "\(totalCompletions(for: habit))")
                                StatCard(title: "Average Daily", value: String(format: "%.1f", averageDaily(for: habit)))
                            }
                            
                            HStack {
                                StatCard(title: "Best Day", value: "\(bestDay(for: habit))")
                                StatCard(title: "Current Streak", value: "\(currentStreak(for: habit)) days")
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private func totalCompletions(for habit: Habit) -> Int {
        entries.filter { $0.habit == habit }.reduce(0) { $0 + $1.count }
    }
    
    private func averageDaily(for habit: Habit) -> Double {
        let habitEntries = entries.filter { $0.habit == habit }
        guard !habitEntries.isEmpty else { return 0 }
        return Double(totalCompletions(for: habit)) / Double(habitEntries.count)
    }
    
    private func bestDay(for habit: Habit) -> Int {
        entries.filter { $0.habit == habit }.map { $0.count }.max() ?? 0
    }
    
    private func currentStreak(for habit: Habit) -> Int {
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0...365 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            if entries.contains(where: { 
                calendar.isDate($0.date, inSameDayAs: date) && $0.habit == habit 
            }) {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 