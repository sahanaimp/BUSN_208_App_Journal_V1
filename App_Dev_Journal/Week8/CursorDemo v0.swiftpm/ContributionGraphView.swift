import SwiftUI

struct ContributionGraphView: View {
    let entries: [HabitEntry]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(getLast365Days(), id: \.self) { date in
                let count = getCount(for: date)
                Rectangle()
                    .fill(colorForCount(count))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(2)
            }
        }
        .padding()
    }
    
    private func getLast365Days() -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<365).map { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)!
        }.reversed()
    }
    
    private func getCount(for date: Date) -> Int {
        entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?.count ?? 0
    }
    
    private func colorForCount(_ count: Int) -> Color {
        switch count {
        case 0: return Color(.systemGray6)
        case 1: return Color.green.opacity(0.3)
        case 2: return Color.green.opacity(0.5)
        case 3: return Color.green.opacity(0.7)
        default: return Color.green
        }
    }
} 