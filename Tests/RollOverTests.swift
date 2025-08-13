import XCTest
@testable import StepPointLite

final class RollOverTests: XCTestCase {
    func testRollOverAppendsHistoryAndResets() {
        var today = DailyStat(date: sampleDate("2024-01-01"), steps: 5_000, points: 30)
        var history: [DailyStat] = [
            DailyStat(date: sampleDate("2023-12-31"), steps: 8_000, points: 48)
        ]
        let service = DateService()
        service.rollOverIfNeeded(current: &today, history: &history, now: sampleDate("2024-01-02"))
        XCTAssertEqual(today.steps, 0)
        XCTAssertEqual(history.count, 2)
        XCTAssertEqual(history.last?.steps, 5_000)
    }

    private func sampleDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: str)!
    }
}
