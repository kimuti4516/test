import Foundation

public final class DateService {
    private let calendar: Calendar

    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    public func startOfToday() -> Date {
        calendar.startOfDay(for: Date())
    }

    public func isSameDay(_ a: Date, _ b: Date) -> Bool {
        calendar.isDate(a, inSameDayAs: b)
    }

    public func needsRollover(from lastDate: Date, now: Date = Date()) -> Bool {
        !isSameDay(lastDate, now)
    }

    public func rollOverIfNeeded(current: inout DailyStat, history: inout [DailyStat], now: Date = Date()) {
        guard needsRollover(from: current.date, now: now) else { return }
        history.append(current)
        if history.count > 6 {
            history.removeFirst(history.count - 6)
        }
        current = DailyStat(date: now, steps: 0, points: 0)
    }
}
