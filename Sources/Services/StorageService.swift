import Foundation

public final class StorageService {
    public static let shared = StorageService()
    private let defaults = UserDefaults.standard

    private let currentDateKey = "currentDate"
    private let currentStepsKey = "currentSteps"
    private let currentPointsKey = "currentPoints"
    private let historyKey = "history"

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    public func loadCurrent() -> DailyStat? {
        guard let dateString = defaults.string(forKey: currentDateKey),
              let date = formatter.date(from: dateString) else {
            return nil
        }
        let steps = defaults.integer(forKey: currentStepsKey)
        let points = defaults.integer(forKey: currentPointsKey)
        return DailyStat(date: date, steps: steps, points: points)
    }

    public func saveCurrent(_ stat: DailyStat) {
        defaults.set(formatter.string(from: stat.date), forKey: currentDateKey)
        defaults.set(stat.steps, forKey: currentStepsKey)
        defaults.set(stat.points, forKey: currentPointsKey)
    }

    public func loadHistory() -> [DailyStat] {
        guard let data = defaults.data(forKey: historyKey),
              let arr = try? JSONDecoder().decode([DailyStat].self, from: data) else {
            return []
        }
        return arr
    }

    public func saveHistory(_ history: [DailyStat]) {
        if let data = try? JSONEncoder().encode(history) {
            defaults.set(data, forKey: historyKey)
        }
    }

    public func clearAll() {
        defaults.removeObject(forKey: currentDateKey)
        defaults.removeObject(forKey: currentStepsKey)
        defaults.removeObject(forKey: currentPointsKey)
        defaults.removeObject(forKey: historyKey)
    }
}
