import Foundation

struct HabitEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let count: Int
    
    init(id: UUID = UUID(), date: Date = Date(), count: Int = 1) {
        self.id = id
        self.date = date
        self.count = count
    }
}

class HabitData: ObservableObject {
    @Published var entries: [HabitEntry] = []
    private let saveKey = "HabitEntries"
    
    init() {
        loadData()
    }
    
    func addEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        if let existingIndex = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            entries[existingIndex] = HabitEntry(id: entries[existingIndex].id, date: today, count: entries[existingIndex].count + 1)
        } else {
            entries.append(HabitEntry(date: today))
        }
        saveData()
    }
    
    func getStreak() -> Int {
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
    
    func getTodayCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })?.count ?? 0
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([HabitEntry].self, from: data) {
            entries = decoded
        }
    }
} 