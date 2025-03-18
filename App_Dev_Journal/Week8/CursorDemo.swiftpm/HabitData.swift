import Foundation

struct HabitEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let count: Int
    let habit: Habit
    
    init(id: UUID = UUID(), date: Date = Date(), count: Int = 1, habit: Habit) {
        self.id = id
        self.date = date
        self.count = count
        self.habit = habit
    }
}

class HabitData: ObservableObject {
    @Published var entries: [HabitEntry] = []
    private let saveKey = "HabitEntries"
    
    init() {
        loadData()
    }
    
    func addEntry(for habit: Habit) {
        let today = Calendar.current.startOfDay(for: Date())
        if let existingIndex = entries.firstIndex(where: { 
            Calendar.current.isDate($0.date, inSameDayAs: today) && $0.habit == habit 
        }) {
            entries[existingIndex] = HabitEntry(
                id: entries[existingIndex].id,
                date: today,
                count: entries[existingIndex].count + 1,
                habit: habit
            )
        } else {
            entries.append(HabitEntry(date: today, habit: habit))
        }
        saveData()
    }
    
    func getStreak(for habit: Habit) -> Int {
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
    
    func getTodayCount(for habit: Habit) -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.first(where: { 
            Calendar.current.isDate($0.date, inSameDayAs: today) && $0.habit == habit 
        })?.count ?? 0
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