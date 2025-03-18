import SwiftUI

struct StatsView: View {
    let entries: [HabitEntry]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ContributionGraphView(entries: entries)
                        .frame(height: 300)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            StatCard(title: "Total Completions", value: "\(totalCompletions)")
                            StatCard(title: "Average Daily", value: String(format: "%.1f", averageDaily))
                        }
                        
                        HStack {
                            StatCard(title: "Best Day", value: "\(bestDay)")
                            StatCard(title: "Current Streak", value: "\(currentStreak) days")
                        }
                    }
                    .padding()
                }
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
    
    private var totalCompletions: Int {
        entries.reduce(0) { $0 + $1.count }
    }
    
    private var averageDaily: Double {
        guard !entries.isEmpty else { return 0 }
        return Double(totalCompletions) / Double(entries.count)
    }
    
    private var bestDay: Int {
        entries.map { $0.count }.max() ?? 0
    }
    
    private var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0...365 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            if entries.contains(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
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